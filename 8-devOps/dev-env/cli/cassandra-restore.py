#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import sys
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

server = choose_one(
    choose_msg="Choose docker cassandra server to backup",
    not_found_msg="No cassandra containers found",
    options=menu,
)

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
        "keyspace_name",
    }
    menu = {entry: entry for entry in keyspaces}
    keyspace = choose_one(
        choose_msg="Choose keyspace to backup",
        not_found_msg="No keyspace found",
        options=menu,
    )

out = server.exec_run(f"ls /dump/{keyspace}/")
if out.exit_code != 0:
    print(f"Error executing command: {out.output.decode('utf-8')}")
    sys.exit(1)
else:
    snapshots = out.output.decode("utf-8").strip().split("\n")
    snapshots = set([entry.strip() for entry in snapshots])
    for snapshot in snapshots:
        p = f"/dump/{keyspace}/{snapshot}"
        out = server.exec_run(f"cqlsh -f {p}/schema.cql")
        print(out)
        out = server.exec_run(f"sstableloader {p} -d {server.name}")
        print(out)
