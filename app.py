from flask import Flask
from flask import request
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.sql import SQL, Literal
from dotenv import load_dotenv
import os
import query

load_dotenv(override=True)

app = Flask(__name__)
app.json.ensure_ascii = False

connection = psycopg2.connect(
    user=os.environ.get("POSTGRES_USER"),
    password=os.environ.get("POSTGRES_PASSWORD"),
    host=os.environ.get("POSTGRES_HOST"),
    port=os.environ.get("POSTGRES_PORT"),
    database=os.environ.get("POSTGRES_DB"),
    cursor_factory=RealDictCursor
)
connection.autocommit = True


@app.route("/", methods=['POST', 'GET'])
def hello_world():
    return "<p>Hello, World!</p>"


@app.get("/firms")
def get_firms():
    query_ =query.GET_FIRMS.format(
        where="")
    with connection.cursor() as cursor:
        cursor.execute(query_)
        result = cursor.fetchall()

    return result


@app.post('/firm/create')
def create_actor():
    body = request.json
    name = body['name']
    phone = body['phone']
    address = body['address']
    foundation_year = body['foundation_year']

    query_ = SQL(query.INSERT_FIRM).format(
        name=Literal(name),
        phone=Literal(phone), 
        address=Literal(address),
        foundation_year=Literal(foundation_year))
    with connection.cursor() as cursor:
        cursor.execute(query_)
        result = cursor.fetchone()
    connection.commit()
    return result


@app.post('/firm/update')
def update_actor():
    body = request.json
    name = body['name']
    phone = body['phone']
    address = body['address']
    foundation_year = body['foundation_year']
    id = body["id"]

    query_ = SQL(query.UPDATE_FIRM).format(name=Literal(name), phone=Literal(phone), address=Literal(address), id=Literal(id), foundation_year=Literal(foundation_year))
    with connection.cursor() as cursor:
        cursor.execute(query_)
        result = cursor.fetchone()

    if len(result) == 0:
        return '', 404

    return ''


@app.delete('/firm/delete')
def delete_actor():
    body = request.json
    id = body['id']
    deleteActor = SQL(query.DELETE_FIRM).format(id=Literal(id))

    with connection.cursor() as cursor:
        cursor.execute(deleteActor)
        result = cursor.fetchall()

    if len(result) == 0:
        return '', 404

    return ''


@app.get('/firm/find_by_name')
def get_firm_by_name():
    name = request.args.get('name')
    query_ = query.GET_FIRMS.format(
        where=f"where f.name ilike '%{name}%'")
    print(query_)
    with connection.cursor() as cursor:
        cursor.execute(query_)
        result = cursor.fetchall()

    return result


@app.get('/firm/find_by_foundation_year')
def get_firm_by_foundation_year():
    foundation_year = request.args.get('foundation_year')
    query_ = query.GET_FIRMS.format(
        where=f"where f.foundation_year = {foundation_year}")
    print(query_)
    with connection.cursor() as cursor:
        cursor.execute(query_)
        result = cursor.fetchall()

    return result

