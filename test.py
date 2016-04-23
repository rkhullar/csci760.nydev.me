#!local/bin/python

import sys, psycopg2
from local.config import auth

con = None

try:
    con = psycopg2.connect(database=auth['dbname'], user=auth['user'], host=auth['host'], password=auth['password'])
    cur = con.cursor()
    cur.execute('select version()')
    ver = cur.fetchone()
    print(ver)

except psycopg2.DatabaseError as e:
    print('Error %s' % e)
    sys.exit(1)

finally:
    if con:
        con.close()