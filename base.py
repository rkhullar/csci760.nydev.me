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

    def commit(self):
        self.con.commit()

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

    def readers(self):
        # id, card, firstname, lastname, email, phone, address, password
        sql = "select * from dbv.reader"
        rows = self.exec(sql)
        out = []
        if rows:
            for row in rows:
                x = {'id'     : row[0],
                     'card'   : row[1],
                     'fname'  : row[2],
                     'lname'  : row[3],
                     'email'  : row[4],
                     'phone'  : row[5],
                     'address': row[6]
                     }
                out.append(x)
        return out

    def add_reader(self, card, fname, lname, email, phone=0, address='NYIT'):
        self.exec('select new.reader(%s,%s,%s,%s,%s,%s)', card, fname, lname, email, phone, address)
        self.commit()

    def branches(self):
        # id, name, address
        sql = 'select * from dbo.branch'
        rows = self.exec(sql)
        out = []
        if rows:
            for row in rows:
                x = {'id': row[0], 'name': row[1], 'address': row[2]}
                out.append(x)
        return out

    @staticmethod
    def support_books(rows):
        out = []
        if rows:
            for row in rows:
                x = {'isbn': row[0],
                     'pubdate': row[1].strftime('%m/%d/%Y'),
                     'title': row[2],
                     'author': row[3],
                     'publisher': row[4],
                     'address': row[5]
                     }
                out.append(x)
        return out

    def books(self):
        # isbn, pubdate, title, author, publisher, address
        sql = "select * from dbv.book"
        rows = self.exec(sql)
        return Core.support_books(rows)

    def search_books(self, x, mode='title'):
        mode = mode.lower()
        if mode not in ['isbn', 'title', 'author', 'publisher']:
            return []
        if mode == 'isbn':
            x = int(x)
        sql = "select * from dbv.book where %s='%s'" % (mode, x)
        rows = self.exec(sql)
        return Core.support_books(rows)

    def add_book_copy(self, branchID, isbn, amt=1):
        sql = "select max(n) from dbo.copy where branchID=%s and isbn=%s"
        rows = self.exec(sql, branchID, isbn)
        n = 0
        if rows[0][0]:
            n = rows[0][0]
        n += 1
        for x in range(amt):
            sql = "insert into dbo.copy(isbn, branchID, n) values (%s, %s, %s)" % (isbn, branchID, n)
            self.cur.execute(sql)
            self.con.commit()
            n += 1

    def status_book_copy(self, branchID, isbn, code):
        sql = "select lock from dbo.copy where branchID=%s and isbn=%s and n=%s"
        rows = self.exec(sql, branchID, isbn, code)
        if rows:
            return 'off shelf' if rows[0][0] else 'on shelf'
        else:
            return None

    def inventory(self):
        # isbn branchID count
        rows = self.exec("select * from dbv.inventory")
        out = []
        if rows:
            for row in rows:
                x = {'isbn': row[0], 'bid': row[1], 'amt': row[2]}
                out.append(x)
        return out

    def inventory_full(self):
        # id isbn branchID n lock
        rows = self.exec("select * from dbo.copy")
        out = []
        if rows:
            for row in rows:
                x = {'isbn': row[1], 'bid': row[2], 'n': row[3], 'status': 'off shelf' if row[4] else 'on shelf'}
                out.append(x)
        return out

    def average_fine_paid(self):
        n = self.exec("select count(*) from map.borrow")[0][0]
        if n > 0:
            return self.exec("select avg(payment) from map.borrow")[0][0]
        else:
            return 0

    def support_item(self, branch_id, isbn):
        sql = "select min(n) from dbo.copy where branchID='%s' and isbn='%s' and lock='false'" % (branch_id, isbn)
        rows = self.exec(sql)
        if rows:
            return rows[0][0]
        return False

    def copy_id(self, branch_id, isbn, code):
        sql = "select id from dbo.copy where branchID='%s' and isbn='%s' and n='%s'" % (branch_id, isbn, code)
        rows = self.exec(sql)
        if rows:
            return rows[0][0]

    def reader_checkout_list(self, reader_id):
        # readerID, branchID, isbn, title, author, duedate
        sql = "select * from dbv.borrow where readerID='%s'" % reader_id
        rows = self.exec(sql)
        out = []
        if rows:
            for row in rows:
                x = {'branch_id': row[1], 'isbn': row[2], 'title': row[3], 'author': row[4], 'duedate': row[5]}
                out.append(x)
        return out

    def reader_reserve_list(self, reader_id):
        # readerID, branchID, isbn, title, author
        sql = "select * from dbv.reserve where readerID='%s'" % reader_id
        rows = self.exec(sql)
        out = []
        if rows:
            for row in rows:
                x = {'branch_id': row[1], 'isbn': row[2], 'title': row[3], 'author': row[4]}
                out.append(x)
        return out

    def reader_checkout_base(self, reader_id, branch_id, isbn, code):
        copy_id = self.copy_id(branch_id, isbn, code)
        # print('copyid = ', copy_id)
        sql = "insert into map.borrow(readerID, copyID) values ('%s', '%s')" % (reader_id, copy_id)
        self.cur.execute(sql)
        self.con.commit()

    def reader_reserve_base(self, reader_id, branch_id, isbn, code):
        copy_id = self.copy_id(branch_id, isbn, code)
        # print('copyid = ', copy_id)
        sql = "insert into map.reserve(readerID, copyID) values ('%s', '%s')" % (reader_id, copy_id)
        self.cur.execute(sql)
        self.con.commit()

    def reader_checkout(self, reader_id, branch_id, isbn):
        # check book copy available
        code = self.support_item(branch_id, isbn)
        if not code:
            return False
        # check reader borrow (10)
        cl = self.reader_checkout_list(reader_id)
        rl = self.reader_reserve_list(reader_id)
        if len(cl) + len(rl) >= 10:
            return False
        # perform the successful checkout
        self.reader_checkout_base(reader_id, branch_id, isbn, code)

    def reader_reserve(self, reader_id, branch_id, isbn):
        # check book copy available
        code = self.support_item(branch_id, isbn)
        if not code:
            return False
        # check reader limit (10)
        cl = self.reader_checkout_list(reader_id)
        rl = self.reader_reserve_list(reader_id)
        if len(cl) + len(rl) >= 10:
            return False
        # perform the successful checkout
        self.reader_reserve_base(reader_id, branch_id, isbn, code)

    def reader_return(self, reader_id, branch_id, isbn):
        return None

    def reader_fines(self, reader_id):
        sql = "select fine from dbv.fines where readerID='%s'" % reader_id
        rows = self.exec(sql)
        if rows:
            return rows[0][0]
        return 0


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
    '''
    for o in XCore.call('books'):
        print(o)
    '''

    for o in XCore.call('search_books', 'Pub 1', 'publisher'):
        print(o)

def test_book_status():
    o = XCore.call('status_book_copy', 1, 1000000000001, 1)
    print(o)

def test_readers():
    for o in XCore.call('readers'):
        print(o)

    XCore.call('add_reader', '12345678', 'test', 'nydev', 'test@nydev.me')

def test_inventory():
    XCore.call('add_book_copy', 1, 1000000000001, 5)
    for o in XCore.call('inventory'):
        print(o)

def test_checkout():
    n = XCore.call('copy_id', 3, 1000000000001, 1)
    print(n)
    n = XCore.call('support_item', 3, 1000000000001)
    print(n)
    # XCore.call('reader_checkout', 1, 1, 1000000000001)
    XCore.call('reader_checkout', 1, 1, 1000000000019)

if __name__ == '__main__':
    test_book_status()
