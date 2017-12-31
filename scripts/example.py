#!/usr/bin/python

# Copyright 2017 Erik Phillips
# Fetch all user information from the database

import pprint
from firebase import firebase

print "Fetching delegation-app users..."

firebase = firebase.FirebaseApplication('https://delegation-app.firebaseio.com/', None)
result = firebase.get('/users', None)

print "Found {} users:".format(len(result))
pprint.pprint(result)


import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate("/Users/erikphillips/Desktop/senior_project/delegation_app/assets/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

