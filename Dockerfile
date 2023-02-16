FROM python:3.8.16-slim-buster

ENV APP_PATH=dbt
ENV PYTHONUNBUFFERED=1
# Install OS dependencies
RUN apt-get update && \
    apt-get -yqq install ssh && \
    apt-get clean

# Create directory for dbt config
RUN mkdir -p /root/.dbt

# Copy dbt profile
COPY profiles.yml /root/.dbt/profiles.yml

# Copy requirements - python packages and other stuff
COPY requirements.txt /

# Install dependencies
RUN pip install --upgrade pip && pip install --no-cache-dir -r /requirements.txt


# Copy project dbt to container
COPY dbt /$APP_PATH

# RUN dbt deps

# Stablish the default path of the container
WORKDIR $APP_PATH