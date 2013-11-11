# -*- coding: utf-8 -*-


def managed(name, user=None, pkgs=None):
    cmd = ['conda', 'create', '--yes', '-n', name, 'pip']
    ret = __salt__['cmd.run_all'](' '.join(cmd), runas=user)

    ans = {}
    ans['name'] = name
    ans['changes'] = {}
    if ret['retcode'] > 0:
        if ret['stderr'].startswith('Error: prefix already exists'):
            # venv already exists
            ans['result'] = True
            ans['comment'] = 'venv %s already exists' % name
        else:
            # error
            ans['result'] = False
            ans['comment'] = ret['stderr']
        return ans
    else:
        # ans['changes']['venv'] = {'new': 'venv created', 'old': 'no venv'}
        ans['result'] = True
        ans['comment'] = 'venv %s created' % name

    if pkgs is not None:
        installation_ans = install(name, pkgs=pkgs, user=user)
        ans['result'] = ans['result'] and installation_ans['result']
        ans['comment'] = ans['comment'] + ' - ' + installation_ans['comment']

    return ans


def install(venv, pkgs=None, user=None):
    base_cmd = ['conda', 'install', '--yes', '-n', venv]

    ans = {}
    ans['name'] = venv
    ans['changes'] = {}
    new_pkgs = []
    old_pkgs = []

    pkgs = pkgs.split(',')
    for pkg in pkgs:
        pkg = pkg.strip()
        cmd = base_cmd + [pkg]
        ret = __salt__['cmd.run_all'](' '.join(cmd), runas=user)

        if ret['retcode'] > 0:
            ans['result'] = False
            ans['comment'] = ret
            return ans

        if ret['stdout'].startswith('# All requested packages already installed'):
            old_pkgs.append(pkg)
        else:
            new_pkgs.append(pkg)

    ans['result'] = True
    comment_base = 'Installed ({0}) - Already installed ({1})'
    comment = comment_base.format(','.join(new_pkgs), ','.join(old_pkgs))
    ans['comment'] = comment
    return ans
