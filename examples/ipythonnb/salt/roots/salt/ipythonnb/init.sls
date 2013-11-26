include:
  - miniconda

packages:
  pkg.installed:
    - names:
      - python-dev
      - python-pip

venv:
  conda.managed:
    - user: ubuntu
    - pkgs: ipython-notebook,numpy,scipy,pandas,scikit-learn
  pip.installed:
    - user: ubuntu
    - name: requests
    - bin_env: /home/ubuntu/anaconda/envs/test_venv/bin/pip

/home/ubuntu/.ipython/profile_nbserver:
  file.recurse:
    - user: ubuntu
    - makedirs: True
    - source: salt://ipythonnb/profile_nbserver

/home/ubuntu/notebooks:
  file.directory:
    - user: ubuntu
    - makedirs: True

start-nbserver:
  cmd.script:
    - source: salt://ipythonnb/start-nbserver.sh
    - cwd: /home/ubuntu/notebooks
    - user: ubuntu
