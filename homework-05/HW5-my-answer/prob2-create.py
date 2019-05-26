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
import time
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
#r = remote(host, port)

conn = sqlite3.connect("hash.db")
c = conn.cursor()

def create_proof_of_work_table(header):
    if len(header) == 17:
        time.sleep(5)
    if len(header) != 20:
        for ascii_number in range(128):
        #for ascii_number in bytearray(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):
        #for ascii_number in bytearray(b"0123456789abcdef"):
            create_proof_of_work_table(header + bytes(chr(ascii_number), "utf-8"))

    else:
        hash_result = hashlib.sha256(header).hexdigest()
        log.info(hash_result[-6:].encode("utf-8") + b": " + header )

        c.execute("SELECT * FROM hashs WHERE suffix=?", (hash_result[-6:].encode("utf-8"),))
        entry = c.fetchone()
        if entry == None:
            c.execute("INSERT INTO hashs VALUES (?, ?)", (hash_result[-6:].encode("utf-8"), header))
            conn.commit()

c.execute("CREATE TABLE IF NOT EXISTS hashs ( suffix CHAR(6) , str CHAR(20) );")
conn.commit()

create_proof_of_work_table(b"")

