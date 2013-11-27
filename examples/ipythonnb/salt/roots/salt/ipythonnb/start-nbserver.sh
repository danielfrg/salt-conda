#!/usr/bin/bash

if [ -f /home/ubuntu/nbserver.pid ]; then
    kill -INT $(cat /home/ubuntu/nbserver.pid);
fi

sudo /home/ubuntu/envs/venv/bin/ipython notebook --ip='0.0.0.0' --port=80 --no-browser &
echo $! > /home/ubuntu/nbserver.pid