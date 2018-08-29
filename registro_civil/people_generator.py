from random import choice, randint
import sys
from datetime import datetime, date
import time
import psycopg2

genders = ['H', 'M']
female_names = []
male_names = []
last_names = []
most_ancient_date = int(datetime.strptime("1950/1/1", "%Y/%m/%d").strftime("%s"))
most_recent_date = int(datetime.strptime("2018/1/1", "%Y/%m/%d").strftime("%s"))
people = 0 if len(sys.argv) == 1 else int(sys.argv[1])
counter = 0

for name in open('female_names.dictionary'):
    female_names.append(name.rstrip('\n'))

for name in open('male_names.dictionary'):
    male_names.append(name.rstrip('\n'))

for name in open('last_names.dictionary'):
    last_names.append(name.rstrip('\n'))


conn = psycopg2.connect("dbname=test user=postgres password=123")
cur = conn.cursor()


def generate_person(aux_dad_lastname, aux_gender, aux_date, prob):
    global counter

    if counter >= people:
        return None

    gender = ""
    if aux_gender == None:
        gender = choice(genders)
    else:
        gender = aux_gender
    name = choice(male_names) if gender == 'H' else choice(female_names)
    dad_lastname = ""
    if aux_dad_lastname == None:
        dad_lastname = choice(last_names)
    else:
        dad_lastname = aux_dad_lastname
    mom_lastname = choice(last_names)
    date = generate_date(aux_date)

    counter += 1

    statistic = randint(0, 100)
    dad = None
    mom = None
    if statistic < prob:
        dad = generate_person(dad_lastname, 'H', date, prob - 15)
    statistic = randint(0, 100)
    if statistic < prob:
        mom = generate_person(mom_lastname, 'M', date, prob - 15)
    if counter >= people:
        return None
    id = insert_person(name, dad_lastname, mom_lastname, datetime.fromtimestamp(date).strftime('%Y-%m-%d'), dad, mom, gender)
    while True:
        statistic = randint(0, 100)
        if statistic < prob / 3:
            generate_sibling(dad_lastname, mom_lastname, date, dad, mom)
        else:
            break
    return id

def generate_sibling(dad_lastname, mom_lastname, aux_date, dad, mom):
    global counter

    if counter >= people:
        return

    gender = choice(genders)
    name = choice(male_names) if gender == 'H' else choice(female_names)
    date = generate_similar_date(aux_date)
    insert_person(name, dad_lastname, mom_lastname, datetime.fromtimestamp(date).strftime('%Y-%m-%d'), dad, mom, gender)

    counter += 1

def generate_similar_date(date):
    tmp_date = datetime.fromtimestamp(date).date()
    final_date = tmp_date.replace(year = tmp_date.year + 5, month = tmp_date.month, day = 1)
    initial_date = final_date.replace(year = final_date.year - 5, month = tmp_date.month, day = 1)
    return randint(time.mktime(initial_date.timetuple()), time.mktime(final_date.timetuple()))

def generate_date(date = 0):
    if date == 0:
        rnd_date = randint(most_ancient_date, most_recent_date)
    else:
        tmp_date = datetime.fromtimestamp(date).date()
        final_date = tmp_date.replace(year = tmp_date.year - 20, month = tmp_date.month, day = 1)
        initial_date = final_date.replace(year = final_date.year - 10, month = final_date.month, day = 1)
        rnd_date = randint(time.mktime(initial_date.timetuple()), time.mktime(final_date.timetuple()))
    return rnd_date

def insert_person(name, dad_lastname, mom_lastname, date, dad_id, mom_id, gender):
    print("%(name)s %(dad_lastname)s %(mom_lastname)s - %(gender)s, %(date)s" % { 'name': name, 'dad_lastname': dad_lastname, 'mom_lastname': mom_lastname, 'gender': gender, 'date': date} )
    cur.execute("INSERT into persona (nombre, apaterno, amaterno, nacimiento, id_padre, id_madre, sexo) VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id_persona;",
                (name, dad_lastname, mom_lastname, date, dad_id, mom_id, gender))
    return cur.fetchone()[0]

while counter < people:
    # print("----------------------- NEW FAMILY TREE HERE -----------------------")
    generate_person(None, None, 0, 90)
    # print(counter)
cur.close()
conn.close()
