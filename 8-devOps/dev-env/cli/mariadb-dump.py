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
containers = client.containers.list(filters={"label": "type=mariadb"})
menu = {c.name: c for c in containers}

server = choose_one(
    choose_msg="Choose docker mariadb server to backup",
    not_found_msg="No mariadb containers found",
    options=menu,
)

databases = server.exec_run(
    'mariadb -D mysql -u root --password=dpass --port=3306 -e "SHOW DATABASES;"'
)
if databases.exit_code != 0:
    print(f"Error executing command: {databases.output.decode('utf-8')}")
    sys.exit(1)
else:
    databases = databases.output.decode("utf-8").strip().split("\n")
    databases = set([db.strip() for db in databases]) - {
        "Database",
        "information_schema",
        "performance_schema",
        "mysql",
        "sys",
    }
    menu = {db: db for db in databases}
    db = choose_one(
        choose_msg="Choose database to backup",
        not_found_msg="No databases found",
        options=menu,
    )
my_env = os.environ.copy()
my_env["GUM_INPUT_HEADER"] = "Backup file name"
result = subprocess.run(
    ["gum", "input", "--value", f"{db}_backup.sql"],
    stdout=subprocess.PIPE,
    text=True,
    env=my_env,
)
if result.stdout != "":
    output = result.stdout.strip()
else:
    sys.exit(0)

out = server.exec_run(
    f"mariadb-dump -h localhost -u root --password=dpass -P 3306 --databases {db} --result-file=/dump/{output}"
)
print(out)
