#!/usr/bin/env bash

sudo docker build -t myjupytercasa .

export TOKEN=$( head -c 30 /dev/urandom | xxd -p )

sudo docker run --restart=always --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxycasa jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999 --port 8000

sudo docker run --restart=always --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=tmpnbcasa -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image=myjupytercasa --port=9999 --admin-port=10000 --pool-size=5 --redirect-uri=/notebooks/eMERLIN_Basic_Calibration_Tutorial.ipynb --command="Xvfb :102 -ac & jupyter notebook --no-browser --port {port} --ip=0.0.0.0 --NotebookApp.base_url=/{base_path} --NotebookApp.port_retries=0"
