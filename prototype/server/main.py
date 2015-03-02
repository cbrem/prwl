"""
TODO:
* host somewhere else
* currently, the server is giving out ids. Can bottle do ids on the client? Should it?
"""

import bottle

idCounter = 1
pins = []

# TODO: option to fetch just one?
@bottle.get('/pins')
def get():
	print "returning pins: ", pins
	return {'pins': pins}

@bottle.post('/pins')
def post():
	global pins, idCounter
	body = bottle.request.json
	pin = body['pin']
	pin['id'] = idCounter
	idCounter += 1
	pins.append(pin)

	print "added pin: ", pin
	return bottle.request.json

@bottle.route('/<filepath:path>')
def static(filepath):
    return bottle.static_file(filepath, root='../clients/web')

bottle.run(host='localhost', port=8080)
