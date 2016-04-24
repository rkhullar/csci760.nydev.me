#!local/bin/python

"""
@author     :   Rajan Khullar
@created    :   4/16/16
@updated    :   4/23/16
"""

from flask import Flask, request, session, render_template, redirect, url_for
app = Flask(__name__)

@app.route('/')
def index():
    if 'name' not in session:
        return redirect(url_for('login'))
    return render_template('home.html', name=session['name'])


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if request.form['email'] == 'rajan@nydev.me':
            session['name'] = 'Rajan'
            return redirect(url_for('index'))
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('name', None)
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
