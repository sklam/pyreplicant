for y in xrange(10000000000000, 100000000000000):
    for i in xrange(2, int(y ** 0.5) + 1):
        if y % i == 0:
            break
    else:
        print 'prime', y