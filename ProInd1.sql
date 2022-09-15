DROP DATABASE IF EXISTS PI01;
CREATE DATABASE PI01;
USE PI01;

SELECT @@global.secure_file_priv; -- Muestra la carpeta de donde solo se pueden a cargar los archivos
SHOW VARIABLES LIKE "secure_file_priv"; -- Idem
SET SQL_SAFE_UPDATES = 0; -- desactivamos el safe mode 

/*Importacion de las tablas*/
DROP TABLE IF EXISTS circuitos;
CREATE TABLE IF NOT EXISTS circuitos (
	`circuitId`		INTEGER,
  	`circuitRef`	VARCHAR(100),
  	`name`			VARCHAR(150),
    `localizacion`	VARCHAR(150),
    `country`		VARCHAR(130),
    `lat`			DECIMAL(13,10),
	`long`			DECIMAL(13,10),
    `alt`			INTEGER,
    `url`			VARCHAR(200),
    PRIMARY KEY (circuitId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\circuitsOk.csv'
INTO TABLE circuitos 
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM circuitos;



DROP TABLE IF EXISTS drivers;
CREATE TABLE IF NOT EXISTS drivers (
	`driverId`		INTEGER,
  	`driverRef`		VARCHAR(30),
  	`number`		INTEGER,
    `code`			VARCHAR(3),
    `forename`		VARCHAR(30),
    `surname`		VARCHAR(30),
	`dob`			DATE,
	`nationality`	VARCHAR(30),
    `url`			VARCHAR(200),
    PRIMARY KEY (driverId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

/* IMPORTE DIRECTAMENTE EL CSV CON TABLE DATA IMPORT WIZARD 
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\drivers.csv'
INTO TABLE drivers 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;
*/
UPDATE `drivers` SET `number` = NULL WHERE `number`= 0;

SELECT * FROM drivers;



DROP TABLE IF EXISTS constructors;
CREATE TABLE IF NOT EXISTS constructors (
	`constructorId`	INTEGER,
  	`constructorRef`VARCHAR(30),
    `name`			VARCHAR(30),
	`nationality`	VARCHAR(30),
    `url`			VARCHAR(200),
    PRIMARY KEY (constructorId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\constructors.csv'
INTO TABLE constructors 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM constructors;



DROP TABLE IF EXISTS races;
CREATE TABLE IF NOT EXISTS races (
	`raceId`		INTEGER,
  	`year`			INTEGER,
    `round`			INTEGER,
	`circuitId`		INTEGER,
    `name`			VARCHAR(40),
    `date`			DATE,
    `time2`			VARCHAR(40),
    `url`			VARCHAR(200),
    PRIMARY KEY (raceId),
    FOREIGN KEY (circuitId) references circuitos(circuitId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

-- IMPORTE DIRECTAMENTE EL CSV CON TABLE DATA IMPORT WIZARD - Asi me quedan las columnas sin comillas
/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\races.csv'

INTO TABLE races 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Se agregan columnas y para sacar de las existentes las comillas
ALTER TABLE `races` ADD `date` DATE DEFAULT "1900-01-01" AFTER `date2`;
UPDATE `races` SET `date` = REPLACE(date2,'"','');
ALTER TABLE `races` DROP `date2`;

ALTER TABLE `races` ADD `name` VARCHAR(40)  AFTER `name2`;
UPDATE `races` SET `name` = REPLACE(name2,'"','');
ALTER TABLE `races` DROP `name2`;

ALTER TABLE `races` ADD `time` TIME DEFAULT "00:00:00"  AFTER `time2`;
UPDATE `races` SET `time2` = 'Sin Dato' WHERE TRIM(`time2`) = "" OR ISNULL(`time2`);
UPDATE `races` SET `time` = REPLACE(time2,'"','');
ALTER TABLE `races` DROP `time2`;
*/
ALTER TABLE `races` ADD `time` TIME DEFAULT "00:00:00"  AFTER `time2`;
UPDATE `races` SET `time2` = NULL WHERE `time2` LIKE "%N%";
UPDATE `races` SET `time` = `time2`;
ALTER TABLE `races` DROP `time2`;

SELECT * FROM races;



DROP TABLE IF EXISTS pit_stops;
CREATE TABLE IF NOT EXISTS pit_stops (
	`raceId`		INTEGER,
  	`driverId`		INTEGER,
    `stop`			INTEGER,
	`lap`			INTEGER,
    `time`			TIME,
    `duration`		VARCHAR(20),
    `milliseconds`	INTEGER,
    FOREIGN KEY (raceId) references races(raceId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\pit_stops.csv'
INTO TABLE pit_stops 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM pit_stops;




DROP TABLE IF EXISTS results;
CREATE TABLE IF NOT EXISTS results (
	`resultId`		INTEGER,
  	`raceId`		INTEGER,
    `driverId`		INTEGER,
	`constructorId`	INTEGER,
    `number`		VARCHAR(20),
	`grid`			INTEGER,
    `position2`		VARCHAR(20),
    `positionText`	VARCHAR(20),
    `positionOrder`	INTEGER,
    `points`		DECIMAL(10,2),
    `laps`			INTEGER,
    `time`			VARCHAR(20),
    `milliseconds2`	VARCHAR(20),
    `fastestLap2`	VARCHAR(20),
    `rank`			VARCHAR(20),
    `fastestLapTime`VARCHAR(20),
    `fastestLapSpeed2`VARCHAR(20),
    `statusId`		INTEGER,
    PRIMARY KEY (resultId),
    FOREIGN KEY (raceId) references races(raceId),
    FOREIGN KEY (driverId) references drivers(driverId),
    FOREIGN KEY (constructorId) references constructors(constructorId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\results.csv'
INTO TABLE results 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

ALTER TABLE `results` ADD `position` INTEGER  AFTER `position2`;
UPDATE `results` SET `position2` = NULL WHERE `position2` LIKE "%N%";
UPDATE `results` SET `position` = `position2`;
ALTER TABLE `results` DROP `position2`;

UPDATE `results` SET `time` = NULL WHERE `time` LIKE "%N%";

ALTER TABLE `results` ADD `milliseconds` INTEGER  AFTER `milliseconds2`;
UPDATE `results` SET `milliseconds2` = NULL WHERE `milliseconds2` LIKE "%N%";
UPDATE `results` SET `milliseconds` = `milliseconds2`;
ALTER TABLE `results` DROP `milliseconds2`;

ALTER TABLE `results` ADD `fastestLap` INTEGER  AFTER `fastestLap2`;
UPDATE `results` SET `fastestLap2` = NULL WHERE `fastestLap2` LIKE "%N%";
UPDATE `results` SET `fastestLap` = `fastestLap2`;
ALTER TABLE `results` DROP `fastestLap2`;

UPDATE `results` SET `rank` = NULL WHERE `rank` LIKE "%N%";

UPDATE `results` SET `fastestLapTime` = NULL WHERE `fastestLapTime` LIKE "%N%";

ALTER TABLE `results` ADD `fastestLapSpeed` DECIMAL(7,4)  AFTER `fastestLapSpeed2`;
UPDATE `results` SET `fastestLapSpeed2` = NULL WHERE `fastestLapSpeed2` LIKE "%N%";
UPDATE `results` SET `fastestLapSpeed` = `fastestLapSpeed2`;
ALTER TABLE `results` DROP `fastestLapSpeed2`;

SELECT * FROM results;




DROP TABLE IF EXISTS lapTimes;
CREATE TABLE IF NOT EXISTS lapTimes (
	`raceId`		INTEGER,
  	`driverId`		INTEGER,
	`lap`			INTEGER,
	`position`		INTEGER,
    `time`			VARCHAR(20),
    `milliseconds`	INTEGER,
    FOREIGN KEY (raceId) references races(raceId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\lap_times\\lap_times_split_1.csv'
INTO TABLE lapTimes 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 0 LINES;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\lap_times\\lap_times_split_2.csv'
INTO TABLE lapTimes 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 0 LINES;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\lap_times\\lap_times_split_3.csv'
INTO TABLE lapTimes 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 0 LINES;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\lap_times\\lap_times_split_4.csv'
INTO TABLE lapTimes 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 0 LINES;

UPDATE `lapTimes` SET `time` = REPLACE(`time`,'"','');

SELECT * FROM lapTimes;



DROP TABLE IF EXISTS qualifying;
CREATE TABLE IF NOT EXISTS qualifying (
	`qualifyId`	INTEGER,
    `raceId`		INTEGER,
  	`driverId`		INTEGER,
    `constructorId`	INTEGER,
	`number`		INTEGER,
	`position`		INTEGER,
    `q1`			VARCHAR(20),
    `q2`			VARCHAR(20),
    `q3`			VARCHAR(20),
    FOREIGN KEY (raceId) references races(raceId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\qualifying.csv'
INTO TABLE qualifying 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

UPDATE `qualifying` SET `q1` = NULL WHERE `q1` LIKE "%N%";
UPDATE `qualifying` SET `q2` = NULL WHERE `q2` LIKE "%N%";
UPDATE `qualifying` SET `q3` = NULL WHERE `q3` LIKE "%N%";

SELECT * FROM qualifying;


# ------------------------------------------------------------------------------------------------------------------------------------

# - Año con más carreras -------------------------------------------------------------------------------------------------------------
SELECT `year` as "Año", count(*) as "Cantidad de Carreras" 
FROM races 
GROUP BY `year` 
ORDER BY count(*) DESC 
LIMIT 1;

#- Piloto con mayor cantidad de primeros puestos -------------------------------------------------------------------------------------
SELECT d.forename, d.surname, count(*)
FROM results r
	JOIN drivers d
    ON (r.driverId = d.driverId)
WHERE positionOrder = 1
GROUP BY r.driverId
ORDER BY count(*) DESC
LIMIT 1;
    

#- Nombre del circuito más corrido --------------------------------------------------------------------------------------------------
SELECT `circuitId`, `name`, count(*)
FROM races
GROUP BY `circuitId`
ORDER BY 3 DESC
LIMIT 1;


# - Piloto con mayor cantidad de puntos en total, cuyo constructor sea de nacionalidad sea American o British -----------------------
SELECT r.driverId, d.forename, d.surname, c.constructorId, c.`name`, c.nationality , SUM(r.points) as Puntos
FROM results r 
	JOIN drivers d
    ON (r.driverId = d.driverId)
    JOIN constructors c
    ON (r.constructorId = c.constructorId)
WHERE (c.nationality = "American" OR c.nationality = "British")
GROUP BY r.driverId
ORDER BY Puntos DESC
LIMIT 1;


SELECT * -- SUM(points)
FROM results r 
	JOIN drivers d
    ON (r.driverId = d.driverId)
    JOIN constructors c
    ON (r.constructorId = c.constructorId)
-- WHERE c.nationality = "British" OR c.nationality = "British"
WHERE r.driverId = 1
-- GROUP BY r.driverId
;    
