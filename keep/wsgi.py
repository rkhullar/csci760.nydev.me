#!bin/python

import sys
import logging

logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, "/srv/nydev/csci760.nydev.me")

from main import app as application
application.secret_key = 'Jx48YpWqp36395M198tT9D68pasbBGEj'
