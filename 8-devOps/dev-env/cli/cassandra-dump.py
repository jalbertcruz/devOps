#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import sys
from pathlib import Path

import docker


def choose_one(choose_msg, not_found_msg, options):
    match len(options.keys()):
        case 0:
            print(not_found_msg)
            sys.exit(0)
        case 1:
            return list(options.values())[0]
        case _:
            my_env = os.environ.copy()
            my_env["GUM_CHOOSE_HEADER"] = choose_msg
            result = subprocess.run(
                ["gum", "choose"] + list(menu.keys()),
                stdout=subprocess.PIPE,
                text=True,
                env=my_env,
            )
            if result.stdout != "":
                return options[result.stdout.strip()]
            else:
                sys.exit(0)


client = docker.DockerClient(base_url="unix://run/user/1000/docker.sock")
containers = client.containers.list(filters={"label": "type=cassandra"})
menu = {c.name: c for c in containers}

# server = choose_one(choose_msg="Choose docker cassandra server to backup", not_found_msg="No cassandra containers found",
#                     options=menu)
server = client.containers.get("cassandra-db")


keyspaces = server.exec_run(
    'cqlsh -t -e "SELECT keyspace_name from system_schema.keyspaces;"'
)
if keyspaces.exit_code != 0:
    print(f"Error executing command: {keyspaces.output.decode('utf-8')}")
    sys.exit(1)
else:
    keyspaces = keyspaces.output.decode("utf-8").strip().split("\n")
    keyspaces = set([entry.strip() for entry in keyspaces])
    keyspaces = filter(lambda x: not "--" in x, keyspaces)
    keyspaces = filter(lambda x: not "rows)" in x, keyspaces)
    keyspaces = set([entry.strip() for entry in keyspaces]) - {
        "",
        "system",
        "system_schema",
        "system_auth",
        "system_distributed",
        "system_traces",
    }
    menu = {entry: entry for entry in keyspaces}
    keyspace = choose_one(
        choose_msg="Choose keyspace to backup",
        not_found_msg="No keyspace found",
        options=menu,
    )

my_env = os.environ.copy()
my_env["GUM_INPUT_HEADER"] = "Backup name"
result = subprocess.run(
    ["gum", "input", "--value", f"{keyspace}"],
    stdout=subprocess.PIPE,
    text=True,
    env=my_env,
)
if result.stdout != "":
    backup_name = result.stdout.strip()
else:
    sys.exit(0)

out = server.exec_run(f"nodetool snapshot --tag {backup_name} {keyspace}")
if out.exit_code != 0:
    print(f"Error executing command: {out.output.decode('utf-8')}")
    sys.exit(1)
else:
    out = out.output.decode("utf-8").strip().split("\n")
    print(out)

out = server.exec_run(f"find /var/lib/cassandra/data/{keyspace}/ -name snapshots")
if out.exit_code != 0:
    print(f"Error executing command: {out.output.decode('utf-8')}")
    sys.exit(1)
else:
    snapshots = out.output.decode("utf-8").strip().split("\n")
    snapshots = set([entry.strip() for entry in snapshots])
    out = server.exec_run(f"mkdir -p /dump/{backup_name}")
    print(out)
    for snapshot in snapshots:
        p = Path(snapshot)
        table_name = p.parts[6].split("-")[0]
        out = server.exec_run(f"cp -r {snapshot}/{backup_name} /dump/{backup_name}/")
        print(out)
        out = server.exec_run(
            f"mv /dump/{backup_name}/{backup_name} /dump/{backup_name}/{table_name}"
        )
        print(out)

out = server.exec_run(f"nodetool clearsnapshot --all {keyspace}")
print(out)
