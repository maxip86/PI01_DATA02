from fastapi import FastAPI
import pymysql

db = pymysql.connect(host= "localhost", database="PI01", user="root", passwd= "MySQL1234" )

cursor = db.cursor()
consulta1 = "SELECT `year` as 'Año', count(*) as 'Cantidad de Carreras' FROM races GROUP BY `year` ORDER BY count(*) DESC LIMIT 1;"
cursor.execute(consulta1)
datos1 = cursor.fetchone()
rta1 = datos1[0]

consulta2 = "SELECT d.forename, d.surname, count(*) FROM results r JOIN drivers d ON (r.driverId = d.driverId) WHERE positionOrder = 1 GROUP BY r.driverId ORDER BY count(*) DESC LIMIT 1;"
cursor.execute(consulta2)
datos2 = cursor.fetchone()
rta2 = datos2[0:2]
rta2

consulta3 = "SELECT r.circuitId, c.`name`, count(*) FROM races r JOIN circuitos c ON ( r.circuitId = c.circuitId) GROUP BY r.circuitId ORDER BY 3 DESC LIMIT 1;"
cursor.execute(consulta3)
datos3 = cursor.fetchone()
rta3 = datos3[1]
rta3

consulta4 = "SELECT r.driverId, d.forename, d.surname, c.constructorId, c.`name`, c.nationality , SUM(r.points) as Puntos FROM results r  JOIN drivers d ON (r.driverId = d.driverId) JOIN constructors c ON (r.constructorId = c.constructorId) WHERE (c.nationality = 'American' OR c.nationality = 'British') GROUP BY r.driverId ORDER BY Puntos DESC LIMIT 1;"
cursor.execute(consulta4)
datos4 = cursor.fetchone()
rta4 = datos4[1:3]
rta4

db.close()


app = FastAPI()

@app.get("/1")
def read_root():
    return {rta1}

@app.get("/2")
def read_root():
    return {rta2}

@app.get("/3")
def read_root():
    return {rta3}

@app.get("/4")
def read_root():
    return {rta4}
