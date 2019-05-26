#!/usr/bin/env python2
import os
import time
import random
import hashlib
import secret

def sha256(content):
    Hash=hashlib.sha256()
    Hash.update(content)
    return Hash.digest()

def challenge():
    randomstring = hex(random.randint(0,2**24))[2:]
    randomstring = "ae8dc2"
    print("Wanna access the service? Pass my challenge first!")
    user = raw_input("Give me an X (<= 20 Bytes) such that sha256(X) ends with {:0>6}: ".format(randomstring)).decode("hex")
    if len(user)>20:
        print("Input too large.")
        os._exit(0)
    hashval = sha256(user).encode("hex")
    if hashval[-6:] == "{:0>6}".format(randomstring):
        print("Challenge Completed. Here is the flag.")
        print(secret.flag)
    else:
        print("You shall not pass! Go away!")
        os._exit(0)

challenge()
