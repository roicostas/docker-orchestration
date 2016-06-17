# Interlock configuration

Services with overlay driver:

- Add labels 
```
lables:
    - "interlock.domain=<service-name>"
    - "interlock.hostname="
    - "interlock.network=<network>"
```

Proxys:

- nginx: add label `interlock.ext.name=nginx`
- haproxy: add label `interlock.ext.name=haproxy`

# Problems

- If several proxies are using interlock all of then will be configured with the same configuration
