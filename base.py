#!local/bin/python

"""
@author     :   Rajan Khullar
@created    :   4/24/16
@updated    :   5/04/16
"""

import sys, psycopg2, hashlib, datetime
from local.config import auth
from model import Person


class Core:
    def __init__(self):
        try:
            self.con = psycopg2.connect(database=auth['dbname'], user=auth['user'], host=auth['host'], password=auth['password'])
            self.cur = self.con.cursor()
        except psycopg2.DatabaseError as e:
            print('Error %s' % e)
            sys.exit(1)

    def close(self):
        if self.con:
            self.con.close()

    @staticmethod
    def show(rows):
        for row in rows:
            print(row)

    def exec(self, query, *args):
        self.cur.execute(query, args)
        return self.cur.fetchall()

    def login(self, card='', email='', pswd=''):
        m = hashlib.sha256()
        p = pswd.encode('utf-8')
        m.update(p)
        p = m.digest()
        if email.strip():
            rows = self.exec("select id from dbo.actor where email=%s and password=%s", email, p)
            if rows:
                return rows[0][0]
        if card.strip():
            rows = self.exec("select id from dbv.reader where card=%s and password=%s", card, p)
            if rows:
                return rows[0][0]
        return False

    def admin(self, id):
        rows = self.exec("select * from dbo.admin where id=%s", id)
        return len(rows) > 0

    def person(self, id):
        rows = self.exec("select firstname, lastname from dbo.actor where id=%s", id)
        if rows:
            return rows[0][0] + ' ' + rows[0][1]
        return False

    def books(self):
        # isbn, pubdate, title, author, publisher, address
        sql = "select * from dbv.book"
        rows = self.exec(sql)
        books = []
        if rows:
            for row in rows:
                x = {'isbn'     : row[0],
                     'pubdate'  : row[1].strftime('%m/%d/%Y'),
                     'title'    : row[2],
                     'author'   : row[3],
                     'publisher': row[4],
                     'address'  : row[5]
                     }
                books.append(x)
        return books


class XCore:
    @staticmethod
    def call(func, *args):
        tocall = getattr(Core, func)
        core = Core()
        res = tocall(core, *args)
        core.close()
        return res


def test_core():
    core = Core()
    id = core.login("rajan@nydev.me", "aaaaaa")
    print(id)
    rows = core.exec("select * from actor where id=%s or firstname=%s", 1, 'Rajan')
    core.show(rows)
    core.close()


def test_xcore():
    id = XCore.call('login', 'admin@nydev.me', 'mypass')
    #id = XCore.call('login', 'rajan@nydev.me', 'aaaaaa')
    print(id)
    admin = XCore.call('admin', id)
    print(admin)

def test_books():
    for b in XCore.call('books'):
        print(b)


if __name__ == '__main__':
    test_books()
