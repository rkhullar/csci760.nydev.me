"""
@author     :   Rajan Khullar
@created    :   4/24/16
@updated    :   4/24/16
"""


class Person:
    def __init__(self, fname, lname, email, pswd=None):
        self.fname = fname
        self.lname = lname
        self.email = email
        self.pswd = pswd

    def __str__(self):
        return '%s %s: %s' % (self.fname, self.lname, self.email)
