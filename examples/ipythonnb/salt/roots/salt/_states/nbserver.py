# -*- coding: utf-8 -*-
import os
import time
import subprocess


def start_server(name, ip='localhost', port=8888, restart=False, pid='/home/ubuntu/nbserver.pid'):
    ans = {}
    ans['name'] = name
    ans['changes'] = {}
    ans['result'] = True
    ans['comment'] = ''

    if os.path.exists(pid):
        if restart:
            # Kill process on that pid
            with open(pid, 'r') as f:
                process_id = f.read()
                cmd = 'kill -INT %s;' % process_id
                proc = subprocess.Popen([cmd])
                proc.communicate()  # wait
                time.sleep(3)
                ans['comment'] += 'Killed process %s' % process_id
                restart = True
        else:
            ans['comment'] += 'Notebook is running'
    else:
        restart = True

    if restart:
        # No notebook is running
        cmd = 'sudo /home/ubuntu/envs/venv/bin/ipython notebook --ip={0} --port={1} --no-browser &'
        cmd += 'echo $! > {2}'
        cmd = cmd.format(ip, port, pid)
        proc = subprocess.Popen([cmd], shell=True, stdin=None, stdout=None, stderr=None, close_fds=True)
        ans['comment'] += 'New notebook running in {0}:{1}'.format(ip, port)
    return ans
