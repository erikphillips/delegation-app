#!/usr/bin/python

# Copyright 2017 Erik Phillips
# Fetch all task information from the database

import pprint
from firebase import firebase

print "Fetching delegation-app tasks..."

firebase = firebase.FirebaseApplication('https://delegation-app.firebaseio.com/', None)
result = firebase.get('/tasks', None)

print "Found {} tasks:".format(len(result))
pprint.pprint(result)
