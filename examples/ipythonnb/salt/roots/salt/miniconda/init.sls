
miniconda:
  file.managed:
    - name: /tmp/miniconda.sh
    - source: http://repo.continuum.io/miniconda/Miniconda-2.0.3-Linux-x86_64.sh
    - source_hash: md5=6c950b24707cde29b65d5452ff03093c
  cmd.wait:
    - name: "bash miniconda.sh -b"
    - user: vagrant
    - cwd: /tmp
    - watch:
        - cmd: miniconda-check
    - require:
      - file: miniconda

miniconda-check:
  cmd.run:
    - name: "[ -d /home/vagrant/anaconda/ ] && echo 'changed=no' || echo 'changed=yes'"
    - stateful: True

/home/vagrant/.bash_profile:
  file.managed:
    - source: salt://miniconda/bash_profile
    - user: vagrant
