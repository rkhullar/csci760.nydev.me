#!local/bin/python

"""
@author     :   Rajan Khullar
@created    :   4/16/16
@updated    :   4/25/16
"""

from flask import Flask, request, session, render_template, redirect, url_for
from base import Core, XCore

app = Flask(__name__)
app.secret_key = 'Jx48YpWqp36395M198tT9D68pasbBGEj'


@app.route('/')
def index():
    if 'id' not in session:
        return redirect(url_for('login'))
    name = XCore.call('person', session['id'])
    if 'admin' in session and session['admin'] == True:
        return render_template('admin.html', name=name)
    else:
        return render_template('home.html', name=name)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if 'id' in session:
        return redirect(url_for('index'))
    if request.method == 'POST':
        card = request.form['card']
        email = request.form['email']
        pswd = request.form['pswd']
        core = Core()
        id = core.login(card, email, pswd)
        if id:
            session['id'] = id
            admin = core.admin(id)
            if admin:
                session['admin'] = True
        core.close()
        return redirect(url_for('index'))
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('id', None)
    if 'admin' in session:
        session.pop('admin', None)
    return redirect(url_for('index'))


@app.route('/admin/deactivate')
def admin_deactivate():
    if 'admin' in session:
        session.pop('admin', None)
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
