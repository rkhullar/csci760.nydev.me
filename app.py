#!local/bin/python

from flask import Flask
app = Flask(__name__)


@app.route('/')
def index():
    return '<h2>Hello, I love Digital Ocean!</h2>'


@app.route('/profile/<username>')
def profile(username):
    return '<h2>Hello, %s</h2>' % username


@app.route('/post/<int:id>')
def post(id):
    return '<h2>post id = %d</h2>' % id

if __name__ == "__main__":
    app.run()
