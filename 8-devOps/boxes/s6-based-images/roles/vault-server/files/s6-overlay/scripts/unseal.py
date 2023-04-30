#!/usr/bin/env python3
import subprocess
import os
import logging
import time

logging.info(f"[vault_1] unsealing")

time.sleep(3)

my_env = os.environ.copy()
UNSEAL_KEY = my_env["UNSEAL_KEY"]
result = subprocess.run(
    ["vault", "operator", "unseal",  UNSEAL_KEY], text=True, env=my_env
)
logging.info(result.stdout)
