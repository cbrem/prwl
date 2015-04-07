from prwl import lm
from models import User

@lm.user_loader
def load_user(username):
	return User.get({'username': username}) or None
