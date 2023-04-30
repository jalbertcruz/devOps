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
containers = client.containers.list(filters={"label": "type=postgres"})
menu = {c.name: c for c in containers}

server = choose_one(
    choose_msg="Choose docker postgres server to restore",
    not_found_msg="No postgres containers found",
    options=menu,
)

databases = server.exec_run(
    'psql -U duser -d postgres -t -c "SELECT datname FROM pg_database;"'
)
if databases.exit_code != 0:
    print(f"Error executing command: {databases.output.decode('utf-8')}")
    sys.exit(1)
else:
    databases = databases.output.decode("utf-8").strip().split("\n")
    databases = set([db.strip() for db in databases]) - {
        "postgres",
        "template0",
        "template1",
    }
    menu = {db: db for db in databases}
    db = choose_one(
        choose_msg="Choose database to restore",
        not_found_msg="No databases found",
        options=menu,
    )

out = server.exec_run(f"ls /dump/")
if out.exit_code != 0:
    print(f"Error executing command: {out.output.decode('utf-8')}")
    sys.exit(1)
else:
    backups = out.output.decode("utf-8").strip().split("\n")
    backups = set([entry.strip() for entry in backups])
    menu = {entry: entry for entry in backups}
    backup_file = choose_one(
        choose_msg="Choose backup file",
        not_found_msg="No backup file found",
        options=menu,
    )

out = server.exec_run(f"psql -U duser -d {db} -f /dump/{backup_file}")
print(out)
