FROM python:3 as build-base

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHONUNBUFFERED=1

# RUN apt-get install -y default-libmysqlclient-dev

RUN pip install --upgrade pip pipenv

WORKDIR /tmp
ADD Pipfile* ./
RUN pipenv lock --requirements > requirements.txt
RUN pip install --install-option="--prefix=/install" -r requirements.txt

FROM python:3-slim AS build
LABEL maintainer="McK KIM mckabi/docker-pipenv-mysql"

RUN set -ex \
    && apt-get -qq update \
    && apt-get -q -y upgrade \
    && apt-get install -y libmariadbclient18

WORKDIR /app

COPY --from=build-base /install /usr/local
COPY --from=build-base /tmp/requirements.txt /app/

ADD flask_app.py /app/

ENV PYTHONUNBUFFERED=1

EXPOSE 8000

ENV FLASK_APP="flask_app"
ENV FLASK_ENV="development"

CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
