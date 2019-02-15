FROM python:3-slim
LABEL maintainer="McK KIM mckabi/docker-pipenv-mysql"

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHONUNBUFFERED=1

RUN set -ex \
    && apt-get -qq update \
    && apt-get -q -y upgrade \
    && apt-get install -y libmariadb2

RUN pip install --upgrade pip
RUN pip install --upgrade pipenv
ADD Pipfile* /app/
WORKDIR /app

RUN set -ex \
    && savedAptMark="$(apt-mark showmanual)" \
    && apt-get install -y --no-install-recommends \
        dpkg-dev \
        gcc \
        libbz2-dev \
        libc6-dev \
        libexpat1-dev \
        libffi-dev \
        libgdbm-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        make \
        tk-dev \
        uuid-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        libmariadb-dev \
        libmariadb-dev-compat \
    && pipenv install --system --deploy \
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual $savedAptMark \
    && find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
        | awk '/=>/ { print $(NF-1) }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/*

ADD flask_app.py /app/

EXPOSE 8000

ENV FLASK_APP="flask_app"
ENV FLASK_ENV="development"

CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
