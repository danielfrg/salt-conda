include:
  - miniconda

packages:
  pkg.installed:
    - names:
      - python-dev
      - python-pip

test_venv:
  conda.managed:
    - user: vagrant
    - pkgs: ipython,tornado,pyzmq,jinja2,numpy,scipy,pandas,scikit-learn
  pip.installed:
    - user: vagrant
    - name: requests
    - bin_env: /home/vagrant/anaconda/envs/test_venv/bin/pip

/home/vagrant/.ipython/profile_nbserver:
  file.recurse:
    - user: vagrant
    - makedirs: True
    - source: salt://ipythonnb/profile_nbserver

/home/vagrant/notebooks:
  file.directory:
    - user: vagrant
    - makedirs: True

start-nbserver:
  cmd.script:
    - source: salt://ipythonnb/start-nbserver.sh
    - cwd: /home/vagrant/notebooks
    - user: vagrant
