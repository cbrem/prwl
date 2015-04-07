from prwl import app
from os import environ

LOCAL_PORT = 8888
app.run(
	host='0.0.0.0',
	port=int(environ.get('PORT', LOCAL_PORT)))
