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
    choose_msg="Choose docker postgres server to backup",
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
        choose_msg="Choose database to backup",
        not_found_msg="No databases found",
        options=menu,
    )

schemas = server.exec_run(
    f'psql -U duser -d {db} -t -c "SELECT schema_name FROM information_schema.schemata;"'
)
if schemas.exit_code != 0:
    print(f"Error executing command: {schemas.output.decode('utf-8')}")
    sys.exit(1)
else:
    schemas = schemas.output.decode("utf-8").strip().split("\n")
    schemas = set([entry.strip() for entry in schemas]) - {
        "information_schema",
        "pg_catalog",
    }
    menu = {entry: entry for entry in schemas}
    schema = choose_one(
        choose_msg="Choose schema to backup",
        not_found_msg="No schema found",
        options=menu,
    )

my_env = os.environ.copy()
my_env["GUM_INPUT_HEADER"] = "Backup file name"
result = subprocess.run(
    ["gum", "input", "--value", f"{schema}_backup.sql"],
    stdout=subprocess.PIPE,
    text=True,
    env=my_env,
)
if result.stdout != "":
    output = result.stdout.strip()
else:
    sys.exit(0)

out = server.exec_run(
    f"pg_dump --username=duser --host=localhost --port=5432 --format=plain -f /dump/{output} --clean --if-exists --inserts -d {db} --schema={schema}"
)
print(out)
