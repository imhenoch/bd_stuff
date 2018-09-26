import csv

file = open('female_names.dictionary', 'w')
with open('tmp_females') as f:
    for line in f:
        file.write("%s\n" % line.split(' ', 1)[0])

file = open('male_names.dictionary', 'w')
with open('tmp_males') as f:
    for line in f:
        file.write("%s\n" % line.split(' ', 1)[0])

file = open('last_names.dictionary', 'w')
with open('tmp_last_names') as f:
    for line in f:
        file.write("%s\n" % line.split(' ', 1)[0])

file = open('companies.dictionary', 'w')
with open('tmp_companies') as f:
    for i, row in enumerate(csv.reader(f, delimiter=',')):
        if i != 0:
            try:
                file.write("%s\n" % row[1])
            except IndexError:
                continue

file = open('products.dictionary', 'w')
with open('tmp_products') as f:
    for i, row in enumerate(csv.reader(f, delimiter=',')):
        if i != 0:
            try:
                file.write("%s,%s\n" % (row[4], row[5]))
            except IndexError:
                continue

file = open('stores.dictionary', 'w')
with open('tmp_stores') as f:
    for i, row in enumerate(csv.reader(f, delimiter=',')):
        if i != 0:
            try:
                file.write("%s\n" % row[0])
            except IndexError:
                continue

file = open('cities.dictionary', 'w')
with open('tmp_cities') as f:
    for i, row in enumerate(csv.reader(f, delimiter=',')):
        if i != 0:
            try:
                file.write("%s,%s\n" % (row[0], row[2]))
            except IndexError:
                continue
