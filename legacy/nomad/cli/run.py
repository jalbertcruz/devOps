import asyncio
import sys
import time

from enum import Enum
import logging

from collections import namedtuple

Cmd = namedtuple('Cmd', ['wd', 'time', 'cmd'])

jobs="sb/payments/sb"

cmds = [
    Cmd('.', 0,
        'docker run -d -e CONSUL_BIND_INTERFACE=eth0 --rm --name=consul-dev -enable-script-checks jalbert/consul:1.7.2'),
    Cmd('.', 3, 'consul-client-start'),
    Cmd('.', 5, 'python cli/load-consul-kv.py'),
    Cmd('resources', 6,
        'envconsul -log-level="err" -consul-addr=172.17.0.2:8500 -prefix nomad- ../cli/bin/webserver-start'),
    Cmd('.', 0, 'nomad agent -dev'),
    Cmd('.', 6,
        'envconsul -log-level="err" -consul-addr=172.17.0.2:8500 -prefix nomad- python cli/servers/consul-monitor.py'),
    Cmd('.', 15,
        f"cli/start-nomad-jobs {jobs}"),
]


async def get_date():
    global cmds

    for cmd in cmds:
        shell_cmd = f"cd {cmd.wd} && sleep {cmd.time} && {cmd.cmd}"
        await asyncio.create_subprocess_shell(shell_cmd)

    return None


asyncio.run(get_date())
