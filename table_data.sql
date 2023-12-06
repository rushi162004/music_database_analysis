-- Table to store information about media types
CREATE TABLE media_type
    (media_type_id int8 PRIMARY KEY,
     name varchar(50)
    );

-- Table to store information about genres
CREATE TABLE genre
    (genre_id int8 PRIMARY KEY,
     name varchar(50)
    );

-- Table to store information about artists
CREATE TABLE artist
    (artist_id int8 PRIMARY KEY,
     name varchar(30)
    );

-- Table to store information about albums with a foreign key referencing artist table
CREATE TABLE album
    (album_id int8 PRIMARY KEY,
     title varchar(50),
     artist_id int8,
     FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
    );

-- Table to store information about employees
CREATE TABLE employee
    (employee_id int8 PRIMARY KEY,
     last_name varchar(30),
     first_name varchar(30),
     title varchar(30),
     reports_to int8,
     levels varchar(30),
     birthdate timestamp,
     hire_date timestamp,
     address varchar(50),
     city varchar(50),
     state varchar(50),
     country varchar(50),
     postal_code varchar(50),
     phone varchar(30),
     fax varchar(30),
     email varchar(30)
    );

-- Table to store information about customers with a foreign key referencing employee table
CREATE TABLE customer
    (customer_id int8 PRIMARY KEY,
     first_name varchar(50),
     last_name varchar(50),
     company varchar(50),
     address varchar(50),
     city varchar(50),
     state varchar(50),
     country varchar(50),
     postal_code varchar(50),
     phone varchar(50),
     fax varchar(50),
     email varchar(50),
     support_rep_id int8,
     FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id)
    );

-- Table to store information about playlists
CREATE TABLE playlist
    (playlist_id int8 PRIMARY KEY,
     name varchar(30)
    );

-- Table to store information about invoices with a foreign key referencing customer table
CREATE TABLE invoice
    (invoice_id int8 PRIMARY KEY,
     customer_id int8,
     invoice_date timestamp,
     billing_address varchar(50),
     billing_city varchar(50),
     billing_state varchar(50),
     billing_country varchar(50),
     billing_postal_code varchar(50),
     total float(20),
     FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    );

-- Table to store information about tracks with foreign keys referencing playlist_track, album, media_type, and genre tables
CREATE TABLE track
    (track_id int8 PRIMARY KEY,
     name varchar(50),
     album_id int8,
     media_type_id int8,
     genre_id int8,
     composer varchar(50),
     milliseconds int8,
     bytes int8,
     unit_price float(20),
     FOREIGN KEY (album_id) REFERENCES album(album_id),
     FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
     FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
    );

-- Table to associate playlists with tracks
CREATE TABLE playlist_track
    (playlist_id int8,
     track_id int8,
     FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
     FOREIGN KEY (track_id) REFERENCES track(track_id)
    );

-- Table to store information about invoice lines with foreign keys referencing invoice and playlist_track tables
CREATE TABLE invoice_line
    (invoice_line_id int8 PRIMARY KEY,
     invoice_id int8,
     track_id int8,
     unit_price float(20),
     quantity int8,
     FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
     FOREIGN KEY (track_id) REFERENCES track(track_id)
    );
ALTER TABLE artist
ALTER COLUMN name TYPE varchar(100);

ALTER TABLE album
ALTER COLUMN title TYPE varchar(250);

ALTER TABLE track
ALTER COLUMN composer TYPE varchar(250);

ALTER TABLE track
ALTER COLUMN name TYPE varchar(250);

