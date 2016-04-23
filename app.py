#!local/bin/python

from flask import Flask, request
app = Flask(__name__)


@app.route('/')
def index():
    return 'Home Page'


@app.route('/profile/<username>')
def profile(username):
    return '<h2>Hello, %s</h2>' % username


@app.route('/post/<int:id>')
def post(id):
    return '<h2>post id = %d</h2>' % id


@app.route('/api/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return request.form['test']
    return 'login form'

if __name__ == "__main__":
    app.run(debug=True)
