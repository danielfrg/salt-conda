# -*- coding: utf-8 -*-
import os
import time
import subprocess


def start_server(name, ip='localhost', port=8888, restart=False):
    '''
    name is the file path with the pid
    '''
    ans = {}
    ans['name'] = name
    ans['changes'] = {}
    ans['result'] = True
    ans['comment'] = ''

    if os.path.exists(name):
        if restart:
            # Kill process on that pid
            with open(name, 'r') as f:
                process_id = f.read().strip()
                proc = subprocess.Popen(['sudo', 'kill', process_id])
                proc.communicate()  # wait
                time.sleep(3)  # sometimes it takes a while
                ans['changes']['old'] = 'Killed process (%s)' % process_id
                restart = True
        else:
            ans['comment'] = 'Notebook is running'
    else:
        restart = True

    if restart:
        # No notebook is running right now
        cmd = 'sudo /home/ubuntu/envs/venv/bin/ipython notebook --ip={0} --port={1} --no-browser &'
        cmd += 'echo $! > {2}'
        cmd = cmd.format(ip, port, name)
        proc = subprocess.Popen([cmd], shell=True, close_fds=True)
        ans['comment'] = 'New notebook running in {0}:{1}'.format(ip, port)
        ans['changes']['new'] = 'New notebook running in {0}:{1}'.format(ip, port)
    return ans
