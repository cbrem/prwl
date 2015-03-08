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

LOCAL_PORT = 8000
ROOT = os.path.abspath(os.path.dirname(__file__))
STATIC_ROOT = os.path.join(ROOT, '../clients/web/')

# id => pin
pins = {}

@bottle.get('/pins')
def get_pins():
	print 'get all', pins.values()
	return {'pins': pins.values()}

@bottle.get('/pins/<id>')
def get_pins(id):
	print 'get one', pins[id]
	return {'pin': pins[id]}

@bottle.put('/pins/<id>')
def put_pin(id):
	global pins
	pin = bottle.request.json['pin']
	print 'put', id, pin
	pin['id'] = id
	pins[id] = pin
	return {'pin': pin}

@bottle.post('/pins')
def post_pin():
	global pins
	pin = bottle.request.json['pin']
	print 'post', pin
	id = pin['id']
	pins[id] = pin
	return {'pin': pin}

@bottle.delete('/pins/<id>')
def delete_pin(id):
	global pins
	pin = bottle.request.json['pin']
	print 'delete', id, pin
	del pins[id]
	return {}

@bottle.route('/')
def foo():
	return '<h1>prowlit.org coming soon!</h1>'
    #return bottle.static_file('index.html', root=STATIC_ROOT)

@bottle.route('/<filepath:path>')
def static(filepath):
    return bottle.static_file(filepath, root=STATIC_ROOT)

bottle.run(
	host='0.0.0.0',
	port=int(os.environ.get('PORT', LOCAL_PORT)),
	reloader=True)
