-- Create Database Statement
DROP DATABASE IF EXISTS election_tweets;
CREATE DATABASE IF NOT EXISTS election_tweets ;

-- Create Megatable Statement
DROP TABLE IF EXISTS tweet_megatable;
CREATE TABLE IF NOT EXISTS tweet_megatable (
created_at VARCHAR(255) DEFAULT NULL,
tweet_id VARCHAR(255) DEFAULT NULL,
tweet VARCHAR(8000) DEFAULT NULL,
likes VARCHAR(255) DEFAULT NULL,
retweet_count VARCHAR(255) DEFAULT NULL,
source VARCHAR(255) DEFAULT NULL,
user_id VARCHAR(255) DEFAULT NULL,
user_name VARCHAR(8000) DEFAULT NULL,
user_screen_name VARCHAR(255) DEFAULT NULL,
user_description VARCHAR(8000) DEFAULT NULL,
user_join_date VARCHAR(255) DEFAULT NULL,
user_followers_count VARCHAR(255) DEFAULT NULL,
user_location VARCHAR(255) DEFAULT NULL, 
lat VARCHAR(255) DEFAULT NULL,
lon VARCHAR(255) DEFAULT NULL,
city VARCHAR(255) DEFAULT NULL,
country VARCHAR(255) DEFAULT NULL,
continent VARCHAR(255) DEFAULT NULL,
state VARCHAR(255) DEFAULT NULL,
state_code CHAR(10) DEFAULT NULL,
collected_at VARCHAR(255) DEFAULT NULL
) ENGINE = INNODB;


LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_joebiden.csv'
INTO TABLE tweet_megatable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_donaldtrump.csv'
INTO TABLE tweet_megatable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;
