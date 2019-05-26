# -*- coding: utf-8 -*-
#!/usr/bin/env python
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

# not yet completed

from pwn import *
import hashlib
import sqlite3
import binascii
#from my_pwn_tools import *

def print_payload(payload, message = None):
    if message != None:
        log.info(message)
    log.info("payload: " + str(payload))
    log.info("payload length: " + str(len(payload)))

context.arch = "amd64"
context.os = "linux"
context.endian = "little"
# ["CRITICAL", "DEBUG", "ERROR", "INFO", "NOTSET", "WARN", "WARNING"]
context.log_level = "DEBUG"
context.terminal = ["tmux", "split-window"] # ["gnome-terminal", "-x", "sh", "-c"] # ["tmux", "neww"]

is_local = False
host = "linux10.csie.org"
port = 15001

conn = sqlite3.connect("hash.db")
c = conn.cursor()

while True:
    r = remote(host, port)
    hash_suffix = r.recvuntil(":")[-7:-1]
    print_payload(hash_suffix)
    query = hash_suffix

    while True:
        try:
            c.execute("SELECT * FROM hashs WHERE suffix=?", (query,))
            answer = c.fetchone()
            break
        except sqlite3.OperationalError:
            continue

    if answer == None:
        r.close()
        continue
    else:
        print(answer)
        print_payload(binascii.hexlify(answer[1]))
        r.sendline(binascii.hexlify(answer[1]))
        sleep(1)
        r.recvuntil(b"}")
        break
        #r.interactive("Pwned # ")


