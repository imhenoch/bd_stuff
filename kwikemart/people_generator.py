from random import choice, randint
import sys
import psycopg2

female_names = []
male_names = []
last_names = []

for name in open('female_names.dictionary'):
    female_names.append(name.rstrip('\n'))

for name in open('male_names.dictionary'):
    male_names.append(name.rstrip('\n'))

for name in open('last_names.dictionary'):
    last_names.append(name.rstrip('\n'))

people = 0 if len(sys.argv) == 1 else int(sys.argv[1])
counter = 0


conn = psycopg2.connect("dbname=rh user=gerente password=pass")
cur = conn.cursor()


def generate_person():
    gender = randint(0, 1)
    name = choice(male_names) if gender == 0 else choice(female_names)
    lastname = choice(last_names)
    last_lastname = choice(last_names)
    rfc = (name + lastname)[:4] + "000000XXX"
    nss = "xxxxxxxxxxx"
    insert(name, lastname, last_lastname, rfc, nss)

def insert(name, lastname, last_lastname, rfc, nss):
    cur.execute("INSERT INTO empleado (nombre, apaterno, amaterno, rfc, nss) values (%s, %s, %s, %s, %s)",
                (name, lastname, last_lastname, rfc, nss))


while counter < people:
    generate_person()
    counter += 1
conn.commit()
cur.close()
conn.close()
