"""
TODO:
* host somewhere else
* currently, the server is giving out ids. Can bottle do ids on the client? Should it?
"""

import os
import bottle

idCounter = 1
pins = []

ROOT = os.path.abspath(os.path.dirname(__file__))
STATIC_ROOT = os.path.join(ROOT, '../clients/web/')

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

@bottle.route('/')
def foo():
	return <h1>prowlit.org coming soon!</h1>
    #return bottle.static_file('index.html', root=STATIC_ROOT)

@bottle.route('/<filepath:path>')
def static(filepath):
    return bottle.static_file(filepath, root=STATIC_ROOT)

bottle.run(host='0.0.0.0', port=int(os.environ.get("PORT", 8000)))
