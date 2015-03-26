from prwl import app
import os

LOCAL_PORT = 8888
app.run(
	host='0.0.0.0',
	port=int(os.environ.get('PORT', LOCAL_PORT)),
	debug=True)
