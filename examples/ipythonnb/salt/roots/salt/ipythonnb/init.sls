
# To use a simple password to login put it in the state
# This is mainly used for local development using vagrant
# To create the password use:
# python -c "import crypt; print crypt.crypt('password', '\$6\$SALTsalt\$')"
ubuntu:
  user.present:
    # - password: $6$SALTsalt$UiZikbV3VeeBPsg8./Q5DAfq9aj7CVZMDU6ffBiBLgUEpxv7LMXKbcZ9JSZnYDrZQftdG319XkbLVMvWcF/Vr/
    - home: /home/ubuntu
    - shell: /bin/bash
    - createhome: True
    - groups:
      - sudo

# If you want extra security can create a file with the public key of you keypair
# and the code above will add it to the authorized keys so you can ssh to the box
sshkey:
  ssh_auth:
    - present
    - user: ubuntu
    - source: salt://ssh_keys/publickey.pub

# packages:
#   pkg.installed:
#     - user: ubuntu
#     - names:
#       - python-dev
#       - python-pip
#       - tmux

# the conda package is installed in the main python installation
# so it needs to be installed by root
conda:
  pip.installed:
    - user: root

conda-check:
  cmd.run:
    - user: ubuntu
    - name: "[ -d /usr/conda-meta ] && echo 'changed=no' || echo 'changed=yes'"
    - stateful: True

# This will create some files into /usr so needs to be by root
conda:
  cmd.wait:
    - user: root
    - name: "conda init"
    - watch:
        - cmd: conda-check

venv:
  conda.managed:
    - user: ubuntu
    - pkgs: ipython-notebook,numpy,scipy,pandas,scikit-learn

luigi:
  pip.installed:
    - user: ubuntu
    - name: luigi
    - bin_env: /home/ubuntu/envs/venv/bin/pip

# --------------------------------------------------
# Special code for the ipython notebook

/home/ubuntu/notebooks:
  file.directory:
    - user: ubuntu
    - makedirs: True

ipythonnb-server:
  nbserver.start_server:
    - port: 80

# start-nbserver:
#   cmd.script:
#     - user: ubuntu
#     - source: salt://ipythonnb/start-nbserver.sh
#     - cwd: /home/ubuntu/notebooks
