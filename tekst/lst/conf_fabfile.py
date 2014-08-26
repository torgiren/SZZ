from fabric.api import *
from fabric.contrib.files import exists, contains
env.warn_only = True
env.disable_known_hosts = True
env.user = 'root'
env.hosts  = [
              '192.168.0.10',
              '192.168.0.11',
              '192.168.0.12',
              '192.168.0.13',
              '192.168.0.14',
              '192.168.0.15',
              ]

def show_problem():
    if exists('/var/problem'):
        run('cat /var/problem')

def fix():
    if contains('/var/problem', 'podmontowany'):
        run ('umount /mnt/autologs')
    if exists('/var/problem'):
        run('./scripts/autologs.sh')

