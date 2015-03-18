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
import json

LOCAL_PORT = 8888
ROOT = os.path.abspath(os.path.dirname(__file__))
STATIC_ROOT = os.path.join(ROOT, 'static')

pins = {}

idCount = 0
def getID():
	global idCount
	idCount += 1
	return idCount

# Create a new pin
@bottle.post('/pins')
def post_pin():
	global pins
	pin = bottle.request.json
	id = getID()
	pin['id'] = id
	pins[id] = pin
	print 'create /pins', pin, id
	return {}

# Get one pin
@bottle.get('/pins/<id>')
def get_pin(id):
	print 'fetch /pins', pins[id], id
	return pins[id]

# Get all pins
@bottle.get('/pins')
def get_pins():
	print 'fetch /pins', pins

	# TODO: weird that we have to force conversion to json
	return json.dumps(pins.values())

# Update a pin
@bottle.put('/pins/<id>')
def put_pin(id):
	global pins
	pin = bottle.request.json
	pins[id] = pin
	print 'update /pins', pins[id], id
	return {}

# Delete one pin
@bottle.delete('/pins/<id>')
def delete_pin(id):
	global pins
	del pins[id]
	print 'delete /pins', id
	return {}

@bottle.route('/<filepath:path>')
def static(filepath):
    return bottle.static_file(filepath, root=STATIC_ROOT)

if __name__ == '__main__':
	bottle.run(
		host='0.0.0.0',
		port=int(os.environ.get('PORT', LOCAL_PORT)),
		reloader=True,
		debug=True)
