# creates list of N items
def listgen(n):
    o = []
    for i in range(n):
        o.append(None)
    return o


# created list of list
def tblgen(r, c):
    o = []
    for i in range(r):
        o.append([])
        for j in range(c):
            o[i].append(None)
    return o
