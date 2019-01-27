# Docker + Pipenv + mysqlclient-python

- Docker : [python:3-slim](https://hub.docker.com/_/python/)
- [Pipenv](https://pipenv.readthedocs.io/)
- [mysqlclient-python](https://pypi.org/project/mysqlclient/)

## Build & Run docker image

```shell
$ docker build --rm -t docker-pipenv-mysql:latest .
...truncated...
Successfully tagged docker-pipenv-mysql:latest
$ docker image ls
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
docker-pipenv-mysql   latest              5a7345a07a7c        11 minutes ago      345MB
$
$ docker run --rm -p 8000:8000 -e FLASK_DB='mysql://DB_USER:DB_PASSWORD@DB_HOST:3306/DB_NAME?charset=utf8' --name docker-pipenv-mysql docker-pipenv-mysql
 * Serving Flask app "flask_app" (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on http://0.0.0.0:8000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 139-307-886
172.17.0.1 - - [27/Jan/2019 09:58:49] "GET / HTTP/1.1" 200 -
```
