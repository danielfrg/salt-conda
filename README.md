salt-conda
==========

Continuum Analytics conda python package manager with saltstack

See an example at [datasciencebox](https://github.com/danielfrg/datasciencebox)

## Crash course

Before eveything download and install anaconda (miniconda)

```yaml
miniconda:
  cmd.run:
    - name: "wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -q -O miniconda.sh && bash miniconda.sh -b -p /home/ubuntu/anaconda && rm miniconda.sh"
    - cwd: /home/ubuntu
    - user: ubuntu
    - onlyif: "test ! -d /home/ubuntu/anaconda"
```

Create a conda venv, if `env` is not specified will be the default conda env (`~/anaconda/bin`)

This will install packages in the `packages` variable, trying the anaconda repo or defaulting to use pip

```yaml
base-env:
  conda.managed:
    - env: base
    - packages: ipython-notebook
    - requirements: /srv/salt/python/requirements.txt
    - conda: /home/ubuntu/anaconda/bin/conda
    - pip: /home/ubuntu/anaconda/envs/base/pip
    - user: ubuntu
    - require:
      - cmd: miniconda
```

Install a single package in an existing env

```yaml
numpy:
  conda.installed:
    - env: base
    - conda: /home/ubuntu/anaconda/bin/conda
    - pip: /home/ubuntu/anaconda/base/bin/pip
    - user: ubuntu
    - require:
      - cmd: miniconda
```
