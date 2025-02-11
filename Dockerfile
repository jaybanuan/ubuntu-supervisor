FROM ubuntu:24.04

WORKDIR /app

COPY ./ ./

RUN <<DOCKERFILE_HEREDOC
#!/bin/bash -ex

# Install packages
apt-get update -y
apt-get install -y python3-venv python3-dev supervisor

# Create virtual environment
python3 -m venv ./venv
./venv/bin/python3 -m pip install -e ./

# Configure supervisor
cat << EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:app1]
command=$(realpath ./venv)/bin/gunicorn ubuntu_supervisor.bootstrap:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:80
environment=PARAM1="1",PARAM2="2"
directory=$(realpath ./)

[program:app2]
command=$(realpath ./venv)/bin/uvicorn --workers 4 --host 0.0.0.0 --port 8080 ubuntu_supervisor.bootstrap:app
environment=PARAM1="apple",PARAM2="banana"
directory=$(realpath /tmp)

EOF

DOCKERFILE_HEREDOC

CMD ["/usr/bin/supervisord"]