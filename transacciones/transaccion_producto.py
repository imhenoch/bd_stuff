import sys
import psycopg2
from random import choice, randint, uniform
from string import ascii_uppercase, digits

rows = 0 if len(sys.argv) == 1 else int(sys.argv[1])
counter = 0
errors = 0

conn = psycopg2.connect("dbname=central user=gerente password=pass host=192.168.1.65")
cur = conn.cursor()

def generate_row():
    global counter
    global errors
    try:
        id_transaccion = randint(1, 5_000_000)
        id_producto = randint(1, 100_000)
        cantidad = round(uniform(0, 100_000), 2)
        precio_final = round(uniform(0, 100_000), 2)
        cur.execute("INSERT INTO transaccion_producto (id_transaccion, id_producto, precio_final, cantidad) VALUES (%s, %s, %s, %s) RETURNING precio_final;",
                     (id_transaccion, id_producto, precio_final, cantidad))
        counter += 1
    except:
        errors += 1

while counter < rows:
    generate_row()

print("%i rows inserted, %i errors detected" %(counter, errors))

conn.commit()
cur.close()
conn.close()