#!/usr/bin/python3
import sys
from passlib.hash import sha512_crypt

if len(sys.argv) == 1 : sys.exit("Provide a password")
print(sha512_crypt.hash(sys.argv[1]))
