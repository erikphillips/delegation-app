
# Fetch all user information from the database

import pprint
from firebase import firebase

print "Fetching delegation-app users..."

firebase = firebase.FirebaseApplication('https://delegation-app.firebaseio.com/', None)
result = firebase.get('/users', None)

print "Found {} users:".format(len(result))
pprint.pprint(result)
