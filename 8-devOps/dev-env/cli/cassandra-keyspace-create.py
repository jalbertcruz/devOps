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
# server = client.containers.get("cassandra-db")

out = server.exec_run(
    """cqlsh -t -e "CREATE KEYSPACE IF NOT EXISTS akka WITH REPLICATION = { 'class' : 'SimpleStrategy','replication_factor':1 };\""""
)
if out.exit_code != 0:
    print(f"Error executing command: {out.output.decode('utf-8')}")
    sys.exit(1)
print(out)
