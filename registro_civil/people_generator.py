from random import choice, randint
import sys
from datetime import datetime, date

genders = ['H', 'M']
female_names = []
male_names = []
last_names = []
birthday_limit = int(datetime.strptime("1900/1/1", "%Y/%m/%d").strftime("%s"))
most_ancient_date = int(datetime.strptime("1950/1/1", "%Y/%m/%d").strftime("%s"))
most_recent_date = int(datetime.strptime("2000/1/1", "%Y/%m/%d").strftime("%s"))
people = 0 if len(sys.argv) == 1 else int(sys.argv[1])

for name in open('female_names.dictionary'):
    female_names.append(name.rstrip('\n'))

for name in open('male_names.dictionary'):
    male_names.append(name.rstrip('\n'))

for name in open('last_names.dictionary'):
    last_names.append(name.rstrip('\n'))



def generate_person():
    gender = choice(genders)
    name = choice(male_names) if gender == 'H' else choice(female_names)
    dad_lastname = choice(last_names)
    mom_lastname = choice(last_names)
    print("%(name)s %(dad_lastname)s %(mom_lastname)s - %(gender)s" % { 'name': name, 'dad_lastname': dad_lastname, 'mom_lastname': mom_lastname, 'gender': gender })

def generate_date(date = 0):
    if date == 0:
        rnd_date = randint(most_ancient_date, most_recent_date)
        print(datetime.fromtimestamp(rnd_date).strftime('%Y-%m-%d'))

for i, number in enumerate(range(people, 0, -1), 1):
    generate_person()
    generate_date()