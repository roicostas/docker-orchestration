#!/bin/bash

# From https://github.com/Kentik/docker-monitor project

COOKIEJAR=$(mktemp)
GRAFANA_URL='http://localhost:3000/'
GRAFANA_API_URL='http://localhost:3000/api/'
GRAFANA_LOGIN='admin'
GRAFANA_PASSWORD='admin'
GRAFANA_DATA_SOURCE_NAME=cadvisor

INFLUXDB_API_REMOTE_URL=http://influxdb:8086
INFLUXDB_DB_NAME=cadvisor
INFLUXDB_DB_LOGIN=root
INFLUXDB_DB_PASSWORD=root

function setup_grafana_session {
  if ! curl -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary "{\"user\":\"${GRAFANA_LOGIN}\",\"email\":\"\",\"password\":\"${GRAFANA_PASSWORD}\"}" \
    --cookie-jar "$COOKIEJAR" \
    "${GRAFANA_URL}login" > /dev/null 2>&1 ; then
    echo
    error "Grafana Session: Couldn't store cookies at ${COOKIEJAR}"
  fi
}

function grafana_has_data_source {
  setup_grafana_session
  curl --silent --cookie "${COOKIEJAR}" "${GRAFANA_API_URL}datasources" \
    | grep "\"name\":\"${GRAFANA_DATA_SOURCE_NAME}\"" --silent
}

function grafana_create_data_source {
  setup_grafana_session
  curl --cookie "${COOKIEJAR}" \
       -X POST \
       --silent \
       -H 'Content-Type: application/json;charset=UTF-8' \
       --data-binary "{\"name\":\"${GRAFANA_DATA_SOURCE_NAME}\",\"type\":\"influxdb\",\"url\":\"${INFLUXDB_API_REMOTE_URL}\",\"access\":\"proxy\",\"database\":\"$INFLUXDB_DB_NAME\",\"user\":\"${INFLUXDB_DB_LOGIN}\",\"password\":\"${INFLUXDB_DB_PASSWORD}\"}" \
       "${GRAFANA_API_URL}datasources" 2>&1 | grep 'Datasource added' --silent;
}

function setup_grafana {
  if grafana_has_data_source; then
    info "Grafana: Data source ${INFLUXDB_DB_NAME} already exists"
  else
    if grafana_create_data_source; then
      success "Grafana: Data source $INFLUXDB_DB_NAME created"
    else
      error "Grafana: Data source $INFLUXDB_DB_NAME could not be created"
    fi
  fi
}

function ensure_grafana_dashboard {
  DASHBOARD_PATH=$1
  TEMP_DIR=$(mktemp -d)
  TEMP_FILE="${TEMP_DIR}/dashboard"

  # Need to wrap the dashboard json, and make sure the dashboard's "id" is null for insert
  echo '{"dashboard":' > $TEMP_FILE
  cat $DASHBOARD_PATH | sed -E 's/^  "id": [0-9]+,$/  "id": null,/' >> $TEMP_FILE
  echo ', "overwrite": true }' >> $TEMP_FILE

  curl --cookie "${COOKIEJAR}" \
       -X POST \
       --silent \
       -H 'Content-Type: application/json;charset=UTF-8' \
       --data "@${TEMP_FILE}" \
       "${GRAFANA_API_URL}dashboards/db" > /dev/null 2>&1
  unlink $TEMP_FILE
  rmdir $TEMP_DIR
}

function success {
  echo "$(tput setaf 2)""$*""$(tput sgr0)"
}

function info {
  echo "$(tput setaf 3)""$*""$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)""$*""$(tput sgr0)" 1>&2
}

cd "$( dirname "${BASH_SOURCE[0]}" )"
setup_grafana
ensure_grafana_dashboard grafana-cadvisor-all_containers.json
