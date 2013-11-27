
# To use a simple password to login put it in the state
# This is mainly used for local development using vagrant
# To create the password use:
# python -c "import crypt; print crypt.crypt('password', '\$6\$SALTsalt\$')"
ubuntu:
  user.present:
    # - password: $6$SALTsalt$UiZikbV3VeeBPsg8./Q5DAfq9aj7CVZMDU6ffBiBLgUEpxv7LMXKbcZ9JSZnYDrZQftdG319XkbLVMvWcF/Vr/
    - shell: /bin/bash

# If you want extra security can create a file with the public key of you keypair
# and the code above will add it to the authorized keys so you can ssh to the box
# sshkey:
#   ssh_auth:
#     - present
#     - user: ubuntu
#     - source: salt://ssh_keys/publickey.pub

packages:
  pkg.installed:
    - user: ubuntu
    - names:
      - python-dev
      - python-pip

# The conda package is installed in the main python installation, needs root
pip-packages:
  pip.installed:
    - user: root
    - names:
      - conda
    - require:
      - pkg: python-dev
      - pkg: python-pip

conda-check:
  cmd.run:
    - user: ubuntu
    - name: "[ -d /usr/conda-meta ] && echo 'changed=no' || echo 'changed=yes'"
    - stateful: True
    - require:
      - pip: conda

# This will create some files into /usr, needs root
conda-init:
  cmd.wait:
    - user: root
    - name: "conda init"
    - watch:
        - cmd: conda-check

venv:
  conda.managed:
    - user: ubuntu
    - pkgs: ipython-notebook,numpy,scipy,pandas,scikit-learn
    - require:
      - cmd: conda-init

venv-pip:
  pip.installed:
    - user: ubuntu
    - names:
      - luigi
    - bin_env: /home/ubuntu/envs/venv/bin/pip
    - require:
      - conda: venv

# --------------------------------------------------
# Special code for the ipython notebook

/home/ubuntu/notebooks:
  file.directory:
    - user: ubuntu
    - makedirs: True

/home/vagrant/nbserver.pid:
  nbserver.start_server:
    - ip: 0.0.0.0
    - port: 80
    - nb_dir: /home/ubuntu/notebooks
    - require:
      - conda: venv
