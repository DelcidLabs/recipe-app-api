FROM python:3.9-alpine3.13
LABEL maintainer="delcidlab"

ENV PYTHONUNBUFFERED 1

# Install necessary build dependencies
RUN apk add --no-cache \
    postgresql-client \
    postgresql-dev \
    musl-dev \
    build-base

# Set the working directory
WORKDIR /app

# Copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Create a virtual environment and install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp

# Clean up build dependencies
RUN apk del build-base postgresql-dev musl-dev

# Create a non-root user
RUN adduser --disabled-password --no-create-home django-user

# Set the PATH for the virtual environment
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user

# Expose the port
EXPOSE 8000
