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
    sql = 'select * from actor'
    cur.execute(sql)
    res = cur.fetchall()
    for row in res:
        print(row)

except psycopg2.DatabaseError as e:
    print('Error %s' % e)
    sys.exit(1)

finally:
    if con:
        con.close()

class A:
    def __init__(self, d):
        self.d = d

    def __str__(self):
        return str(self.d)