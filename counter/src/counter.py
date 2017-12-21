#!/usr/bin/env python
from flask import Flask, render_template
import redis

app = Flask(__name__)
app.config['DEBUG'] = True
redis = redis.Redis("redis")

@app.route("/")
def index():
    count = 1
    bcount = redis.get('count')

    if bcount:
        count = int(bcount.decode('utf8')) + 1
    redis.set('count', str(count))

    return render_template('index.html', count=count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
