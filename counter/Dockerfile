FROM python:3.5-alpine

RUN pip install flask
RUN pip install redis

COPY src /src

WORKDIR /src
EXPOSE 5000
CMD ["python", "counter.py"]
