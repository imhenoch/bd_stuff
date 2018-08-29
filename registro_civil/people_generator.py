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
counter = 0

for name in open('female_names.dictionary'):
    female_names.append(name.rstrip('\n'))

for name in open('male_names.dictionary'):
    male_names.append(name.rstrip('\n'))

for name in open('last_names.dictionary'):
    last_names.append(name.rstrip('\n'))



def generate_person(aux_dad_lastname, aux_gender, aux_date, prob):
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
    print("%(name)s %(dad_lastname)s %(mom_lastname)s - %(gender)s, %(date)s" %
    { 'name': name, 'dad_lastname': dad_lastname, 'mom_lastname': mom_lastname, 'gender': gender, 'date': datetime.fromtimestamp(date).strftime('%Y-%m-%d')} )

    statistic = randint(0, 100)
    if statistic < prob:
        dad = generate_person(dad_lastname, 'H', date, prob - 25)
    statistic = randint(0, 100)
    if statistic < prob:
        mom = generate_person(mom_lastname, 'M', date, prob - 25)
    return prob

def generate_date(date = 0):
    if date == 0:
        rnd_date = randint(most_ancient_date, most_recent_date)
    else:
        rnd_date = randint(most_ancient_date, date)
    return rnd_date

# for i, number in enumerate(range(people, 0, -1), 1):
generate_person(None, None, 0, 100)
