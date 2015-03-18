'''
TODO:
* currently, the server is giving out ids. Can bottle do ids on the client? Should it?

IDs are freaking confusing! But what worked was:
* our js specifically sets 'id' before sending a POST. the response is exactly what we got
* GETs also respond with the id as a normal field
* PUTs do *not* have the ID as a field when ember auto-sends them, but we get it from the route, and set it as a field for the response
'''

import os
import bottle

LOCAL_PORT = 8888
ROOT = os.path.abspath(os.path.dirname(__file__))
STATIC_ROOT = os.path.join(ROOT, 'static')

# id => pin
pins = {}

idCount = 0
def getID():
	global idCount
	idCount += 1
	return idCount

# Get all pins
@bottle.get('/pins')
def get_pins():
	print 'fetch /pins', pins
	return pins

# Create a new pin
@bottle.post('/pin')
def post_pin():
	global pins
	pin = bottle.request.json
	id = getID()
	pins[id] = pin
	print 'create /pin', pin, id
	return {'id': id}

# Get one pin
@bottle.get('/pin/<id>')
def get_pins(id):
	print 'fetch /pin', pins[id], id
	return pins[id]

# Update a pin
@bottle.put('/pin/<id>')
def put_pin(id):
	global pins
	pin = bottle.request.json
	pins[id] = pin
	print 'update /pin', pins[id], id
	return {}

# Delete one pin
@bottle.delete('/pin/<id>')
def delete_pin(id):
	global pins
	del pins[id]
	print 'delete /pin', id
	return {}

@bottle.route('/<filepath:path>')
def static(filepath):
    return bottle.static_file(filepath, root=STATIC_ROOT)

bottle.run(
	host='0.0.0.0',
	port=int(os.environ.get('PORT', LOCAL_PORT)),
	reloader=True)
