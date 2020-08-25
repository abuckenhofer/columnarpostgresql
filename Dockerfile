FROM postgres:12.4

LABEL maintainer="Andreas.Buckenhofer@gmail.com"
LABEL org.label-schema.schema-version="1.1"
LABEL org.label-schema.name="ColumnarPostgreSQL"
LABEL org.label-schema.description="PostgreSQL with columnstore cstore extension for analytical workloads"
LABEL org.label-schema.url="https://github.com/citusdata/cstore_fdw"
LABEL org.label-schema.vcs-url = "https://github.com/abuckenhofer/columnarpostgresql"
LABEL org.label-schema.docker.cmd="docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=setpassword -v /data/postgres:/var/lib/postgresql/data --name columnarpostgresql abuckenhofer/columnarpostgresql:latest"

RUN apt-get update -y -qq && \
    apt-get -y -qq install protobuf-c-compiler libprotobuf-c0-dev unzip git build-essential

RUN apt-get update \
    && apt-get install -y \
        postgresql-server-dev-all \
        postgresql-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone https://github.com/citusdata/cstore_fdw.git && \
    cd cstore_fdw && \
    make -j"$(nproc)" && \
    make install && \
    cd .. && \
    rm -rf cstore_fdw

RUN sed -i "s/#shared_preload_libraries = ''/shared_preload_libraries = 'cstore_fdw'/g" /usr/share/postgresql/postgresql.conf.sample

WORKDIR /usr/src/postgres
