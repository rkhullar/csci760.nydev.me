#!local/bin/python

"""
@author     :   Rajan Khullar
@created    :   4/16/16
@updated    :   5/03/16
"""

from base import Core, XCore
from functools import wraps
from flask import Flask, request, session, render_template, redirect, url_for

app = Flask(__name__)
app.secret_key = 'Jx48YpWqp36395M198tT9D68pasbBGEj'

# Decorator Definitions
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'id' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated


def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'admin' in session and session['admin'] == True:
            return f(*args, **kwargs)
        return redirect(url_for('index'))
    return decorated

# Error Handlers
@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404


# Login System
@app.route('/')
@login_required
def index():
    if 'admin' in session and session['admin'] == True:
        return redirect(url_for('admin'))
    else:
        return redirect(url_for('home'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    # check if user is already logged in
    if 'id' in session:
        return redirect(url_for('index'))

    # handle login request
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

    # send the login form
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

# Admin Routes
@app.route('/admin')
@admin_required
def admin():
    name = XCore.call('person', session['id'])
    return render_template('admin.html', name=name)

# Reader Routes
@app.route('/home', methods=['GET', 'POST'])
@login_required
def home():
    g = ['alpha', 'beta', 'gamma']
    msg = form_match(g, request)
    return render_template('home.html',
                           msg=msg,
                           name=XCore.call('person', session['id']),
                           books=XCore.call('books'))

# Support Funcitons
def form_match(search, request):
    o = None
    for item in search:
        if item in request.form:
            o = item
    return o

''' Example Routes

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
'''

if __name__ == "__main__":
    app.run(debug=True)
