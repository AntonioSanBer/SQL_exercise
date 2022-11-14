DROP SCHEMA IF EXISTS ubd_20211 CASCADE;

CREATE SCHEMA ubd_20211 AUTHORIZATION postgres;

GRANT ALL ON
SCHEMA ubd_20211 TO postgres;

SET
search_path TO ubd_20211;
BEGIN
	WORK;

SET
TRANSACTION READ WRITE;

SET
datestyle = DMY;

CREATE TABLE MUSICIAN (
	id_musician SMALLINT,
	name VARCHAR(255) NOT NULL,
	birth DATE NOT NULL,
	death DATE,
	age SMALLINT,
	gender VARCHAR(255) NOT NULL,
	nationality VARCHAR(255) NOT NULL,
	CONSTRAINT PK_MUSICIAN PRIMARY KEY(id_musician),
	CONSTRAINT GENDER CHECK (gender IN ('M', 'F')),
    CONSTRAINT CHECK_DEATH CHECK (death IS NULL
	OR birth < death));

CREATE TABLE BAND (
	id_band SMALLINT,
	name VARCHAR(255) NOT NULL,
	year_formed SMALLINT NOT NULL,
	year_dissolution SMALLINT,
	STYLE VARCHAR(255) NOT NULL,
	origin VARCHAR(255) NOT NULL,
    CONSTRAINT PK_BAND PRIMARY KEY(id_band),
    CONSTRAINT CHECK_DISSOLUTION CHECK (year_dissolution IS NULL
	OR year_dissolution > year_formed),
    CONSTRAINT STYLE_VALID CHECK (STYLE IN ('Blues', 'Country', 'Heavy', 'Jazz', 'Pop', 'Punk', 'Reggae', 'Rock', 'Soul', 'Thrash', 'Techno')));

CREATE TABLE ALBUM (
	id_album SMALLINT,
	title VARCHAR(255) NOT NULL,
	YEAR SMALLINT NOT NULL,
	id_band SMALLINT NOT NULL,
	num_long_title_songs SMALLINT NOT NULL DEFAULT 0,
	CONSTRAINT PK_ALBUM PRIMARY KEY(id_album),
	CONSTRAINT FK_BAND_ALBUM FOREIGN KEY (id_band) REFERENCES BAND(id_band));

CREATE TABLE MEMBER (
	id_musician SMALLINT, 
	id_band SMALLINT, 
	instrument VARCHAR(255),
	CONSTRAINT PK_MEMBER PRIMARY KEY(id_musician, id_band, instrument),
	CONSTRAINT CHECK_INSTRUMENT CHECK (instrument IN ('Bass', 'Drums', 'Guitar', 'Keyboard', 'Vocals', 'Trumpet', 'Clarinet', 'Oboe', 'Flute')));

CREATE TABLE SONG(
	id_song SMALLINT,
	title VARCHAR(255) NOT NULL,
	duration TIME NOT NULL,
	id_album SMALLINT ,
	CONSTRAINT PK_SONG PRIMARY KEY(id_song),
	CONSTRAINT FK_ALBUM FOREIGN KEY(id_album) REFERENCES ALBUM(id_album) ON DELETE SET NULL,
	CONSTRAINT CHECK_DURATION CHECK (duration > '0:00'));

CREATE TABLE COMPOSER(
	id_musician SMALLINT,
	id_song SMALLINT,
	awards SMALLINT NOT NULL DEFAULT 0 CHECK (awards >= 0),
	CONSTRAINT PK_COMPOSER PRIMARY KEY(id_musician,
	id_song),
	CONSTRAINT FK_SONG_COMPOSER FOREIGN KEY (id_song) REFERENCES SONG(id_song) ON
	UPDATE
	CASCADE,
	CONSTRAINT FK_MUSICIAN_COMPOSER FOREIGN KEY (id_musician) REFERENCES MUSICIAN(id_musician) ON
	UPDATE
		CASCADE);
	
CREATE TABLE REPORT_BAND (
	id_band INTEGER NOT NULL,
	num_instruments INTEGER,
	num_members_alive INTEGER,
	longest_album_title VARCHAR(255),
	num_short_songs INTEGER,
	CONSTRAINT PK_REPORT_BAND PRIMARY KEY(id_band));

CREATE TYPE REPORT_BAND_TYPE AS (
	t_id_band INTEGER,
	t_num_instruments INTEGER,
	t_num_members_alive INTEGER,
	t_longest_album_title VARCHAR(255),
	t_num_short_songs INTEGER);

COMMIT;