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
