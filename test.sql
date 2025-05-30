--create database
CREATE DATABASE conservation_db;

-- create tables 
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id),
    species_id INT REFERENCES species (species_id),
    location VARCHAR(150) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- insert data into tables 

INSERT into rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King','Mountain Range');


INSERT onto species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris','1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus','1758-01-01', 'Endangered');



INSERT into sightings (sighting_id, ranger_id, species_id, location, sighting_time, notes) values 
(1, 1, 1, 'Peak Ridge','2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00','Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- select data from tables
SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;




--Problem 1:

INSERT INTO rangers (name, region) 
VALUES ('Derek Fox' , 'Coastal Plains' )

--problem 2:
SELECT count (DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3:
SELECT * FROM sightings WHERE location ILIKE '%Pass%'

--problem 4:
SELECT name, COUNT(sighting_id) AS total_sightings
FROM rangers
  LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
  GROUP BY
  rangers.ranger_id, rangers.name;

-- Problem 5:
SELECT common_name FROM species
  LEFT JOIN sightings ON species.species_id = sightings.species_id
  WHERE sightings.sighting_id IS NULL;


-- Problem 6:
SELECT common_name, sighting_time, name FROM sightings
    LEFT JOIN rangers ON sightings.ranger_id = rangers.ranger_id
    LEFT JOIN species ON sightings.species_id = species.species_id
    ORDER BY sightings.sighting_time DESC LIMIT 2;

-- Problem 7:
UPDATE species 
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


-- Problem 8:
SELECT sighting_id,
CASE 
    WHEN extract(HOUR from sighting_time) < 12 THEN 'Morning'
    WHEN extract(HOUR from sighting_time) BETWEEN 12 And 17 THEN 'Afternoon'
    ELSE 'Evening' 
END as time_of_day
FROM sightings;

-- Problem 9:
DELETE FROM rangers WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);
