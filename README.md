## CSCI760 Final Project


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

## Links
https://www.digitalocean.com/community/tutorials/how-to-run-django-with-mod_wsgi-and-apache-with-a-virtualenv-python-environment-on-a-debian-vps
https://www.digitalocean.com/community/tutorials/how-to-deploy-a-flask-application-on-an-ubuntu-vps
http://blog.miguelgrinberg.com/post/designing-a-restful-api-with-python-and-flask