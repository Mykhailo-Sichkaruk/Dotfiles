#! /usr/bin/env python
from subprocess import check_output

def get_pass(account):
    return check_output("pass show neomutt/" + account , shell=True).rstrip(b"\n")
