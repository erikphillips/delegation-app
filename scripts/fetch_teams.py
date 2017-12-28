#!/usr/bin/python

# Copyright 2017 Erik Phillips
# Fetch all team information from the database

import pprint
from firebase import firebase

print "Fetching delegation-app teams..."

firebase = firebase.FirebaseApplication('https://delegation-app.firebaseio.com/', None)
result = firebase.get('/teams', None)

print "Found {} teams:".format(len(result))
pprint.pprint(result)
