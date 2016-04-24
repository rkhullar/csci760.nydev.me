"""
@author     :   Rajan Khullar
@created    :   3/26/16
@updated    :   4/24/16
"""


class DataList:
    def __init__(self, kls):
        self.kls = kls
        self.list = []

    def __str__(self):
        return "\n".join(map(str, self.list))

    def add(self, *args):
        item = self.kls(*args)
        self.list.append(item)

    # not tested
    def load(self, path):
        N = 0
        with open(path, 'r') as file:
            next(file)
            for line in file:
                self.load1(line)
                N += 1
        return N

    def load1(self, line):
        pass

    def persist(self):
        pass
