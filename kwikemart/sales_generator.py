##Inserts into sales and sales_details

## ARG PARAMS {rows} {stores} {employees}
## {stores} & {employees} PARAMS SHOULD BE INTEGERS AND TABLES SHOULDN'T HAVE UNSECUENTIAL IDS
import random
import sys
import psycopg2


rows = int(sys.argv[1]) if len(sys.argv) > 1 else 0
stores = int(sys.argv[2]) if len(sys.argv) > 2 else 0
products = int(sys.argv[3]) if len(sys.argv) > 3 else 0

#employees = int(sys.argv[3]) if len(sys.argv) > 3 else 0


counter = 0

conn = psycopg2.connect("dbname=kwikemart user=gerente password=cisco")
cur = conn.cursor()


def generate_row():
  id_store = random.randint(1,stores)
#    id_employee = random.random.randint(1,employees)
  id_sale = insert(id_store)
  create_details(id_sale)

def insert(id_store):
  cur.execute("INSERT INTO sale (id_store) values (%s) RETURNING id_sale", (id_store,) )
  id_gen = cur.fetchone()[0]
  return id_gen

def create_details(id_sale):
  details = random.randint(1,50)
  counter_details = 0

  while counter_details < details:
    id_product = random.randint(1000,products)
    cur.execute("INSERT INTO sale_detail(id_sale,id_product) values(%s,%s)",(id_sale, id_product))
    counter_details += 1

while counter < rows:
  generate_row()
  counter += 1

conn.commit()
cur.close()
conn.close()

