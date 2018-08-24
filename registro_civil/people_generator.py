import random

female_names = []
male_names = []
last_names = []

def read_data():
    for name in open('female_names.dictionary'):
        female_names.append(name.rstrip('\n'))

    for name in open('male_names.dictionary'):
        male_names.append(name.rstrip('\n'))

    for name in open('last_names.dictionary'):
        last_names.append(name.rstrip('\n'))

read_data()
