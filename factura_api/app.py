from flask import Flask, jsonify, request
import psycopg2

app = Flask(__name__)

@app.route('/rfc_exists', methods=['POST'])
def rfc_exists():
    json_data = request.get_json()
    conn = psycopg2.connect("dbname=central user=gerente host=central password=pass")
    cur = conn.cursor()
    cur.execute("select count(*) from admin.cliente where rfc = %s", 
                (json_data['rfc'],))
    result = cur.fetchone()
    data = {'rfc_exists': result[0] > 0}
    cur.close()
    conn.close()
    return jsonify(data)

@app.route('/client', methods=['POST'])
def create_client():
    json_data = request.get_json()
    conn = psycopg2.connect("dbname=central user=gerente host=central password=pass")
    cur = conn.cursor()
    cur.execute("insert into admin.cliente (rfc, razon_social, domicilio) values (%s, %s, %s)", 
                (json_data['rfc'], json_data['razon_social'], json_data['domicilio'],))
    data = {'result': 'success'}
    conn.commit()
    cur.close()
    conn.close()
    return jsonify(data)

@app.route('/cfdi', methods=['GET'])
def get_cfdis():
    conn = psycopg2.connect("dbname=central user=gerente host=central password=pass")
    cur = conn.cursor()
    cur.execute("select * from admin.cfdi")
    result = cur.fetchall()
    data = []
    for cfdi in result:
        data.append({'cfdi': cfdi[0], 'descripcion': cfdi[1]})
    cur.close()
    conn.close()
    return jsonify(data)

@app.route('/bill', methods=['POST'])
def create_bill():
    json_data = request.get_json()
    conn = psycopg2.connect("dbname=central user=gerente host=central password=pass")
    cur = conn.cursor()
    md5 = json_data['rfc'] + str(json_data['transaccion'])
    cur.execute("insert into admin.factura values (%s, %s, now(), md5(%s), md5(%s), md5(%s), md5(%s), md5(%s), %s)",
                (
                    json_data['transaccion'],
                    json_data['rfc'],
                    md5,
                    md5,
                    md5,
                    md5,
                    md5,
                    json_data['cfdi']
                ))
    data = {'result': 'success'}
    conn.commit()
    cur.close()
    conn.close()
    return jsonify(data)