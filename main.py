#!local/bin/python

"""
@author     :   Rajan Khullar
@created    :   4/16/16
@updated    :   4/24/16
"""

from flask import Flask, request, session, render_template, redirect, url_for
from base import Core, XCore

app = Flask(__name__)
app.secret_key = 'Jx48YpWqp36395M198tT9D68pasbBGEj'

'''
people = [
    Person(fname='Rajan', email='rajan@nydev.me', lname='Khullar'),
    Person('Melody', 'He', 'melody@gmail.com')
]
'''


@app.route('/')
def index():
    if 'id' not in session:
        return redirect(url_for('login'))
    name = XCore.call('person', session['id'])
    return render_template('home.html', name=name)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if 'id' in session:
        return redirect(url_for('index'))
    if request.method == 'POST':
        core = Core()
        id = core.login(request.form['email'])
        if id:
            session['id'] = id
        core.close()
        return redirect(url_for('index'))
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('id', None)
    return redirect(url_for('index'))


@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)


@app.route('/profile/<username>')
def profile(username):
    return '<h2>Hello, %s</h2>' % username


@app.route('/post/<int:id>')
def post(id):
    return '<h2>post id = %d</h2>' % id


if __name__ == "__main__":
    app.run(debug=True)
