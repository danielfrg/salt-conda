#!/usr/bin/env bash

if [ -f /home/vagrant/nbserver.pid ]; then
    kill -INT $(cat /home/vagrant/nbserver.pid);
fi

# sudo /home/vagrant/anaconda/envs/test_venv/bin/ipython notebook --profile=nbserver &
# echo $! > /home/vagrant/nbserver.pid