## ***CSCI760 Final Project***

### Python Setup

Python Version: 3.4

Add Correct WSGI to Apache:
``` sh
sudo apt-get install libapache2-mod-wsgi-py3
```

Create Your Virtual Environment:
``` sh
virtualenv -p python3 local
. local/bin/activate
pip install psycopg2
pip install Flask
deactivate
```

### Database Setup
**variables**
1. _user_:  this user should have ownership over all project files
2. _db_:    the database
3. _script.sql_
``` sh
$ sudo adduser _user_
$ sudo su -l postgres
$ psql
- create user _user_ with superuser password _pass_; 
- create database _db_ owner _user_;
- alter role _user_ in database _db_ set search_path to public,dbo,new;
$ su -l _user_
$ psql -d _db_ < _script.sql_
```

### Postgres Shortcuts
``` sh
\l # list databases
\i path/to/script.sql
\dt # list tables
\c _db_ # connect to a database
\dt # list tables
\dS # list views
\df # list functions
\du # display roles
\q # quit
\! clear # clear screen
```

### Links
1. [Django Apache] [django-apache]
2. [Digital Ocean Flask] [ocean-flask]
3. [Rest API] [rest-api]
4. [Quickstart Flask] [flask-quick]
5. [Flask Decorators] [flask-decor] 

[django-apache]: https://www.digitalocean.com/community/tutorials/how-to-run-django-with-mod_wsgi-and-apache-with-a-virtualenv-python-environment-on-a-debian-vps
[ocean-flask]: https://www.digitalocean.com/community/tutorials/how-to-deploy-a-flask-application-on-an-ubuntu-vps
[rest-api]: http://blog.miguelgrinberg.com/post/designing-a-restful-api-with-python-and-flask
[flask-quick]: http://flask.pocoo.org/docs/0.10/quickstart/
[flask-decor]: http://flask.pocoo.org/docs/0.10/patterns/viewdecorators/