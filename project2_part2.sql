-- Create Database Statement
DROP DATABASE IF EXISTS election_tweets;
CREATE DATABASE IF NOT EXISTS election_tweets ;

-- Other potential columns:
-- entry_id (each csv file has a tweet_id but if we combine them we'll need a new unique ID)
-- candidate (to keep track of which dataset they came from, could easily be added as 0/1 so we can get counts later)
-- like/retweet ratio?? (not sure it would really be useful but could end up being so)
-- tweet_popularity (total of like and retweet count)





-- Create Megatable Statement
DROP TABLE IF EXISTS biden_tweet_megatable;
CREATE TABLE IF NOT EXISTS biden_tweet_megatable (
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
user_location VARCHAR(8000) DEFAULT NULL, 
lat VARCHAR(255) DEFAULT NULL,
lon VARCHAR(255) DEFAULT NULL,
city VARCHAR(255) DEFAULT NULL,
country VARCHAR(255) DEFAULT NULL,
continent VARCHAR(255) DEFAULT NULL,
state VARCHAR(255) DEFAULT NULL,
state_code VARCHAR(255) DEFAULT NULL,
collected_at VARCHAR(255) DEFAULT NULL
) ENGINE = INNODB;


LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_joebiden.csv'
INTO TABLE biden_tweet_megatable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;

DROP TABLE IF EXISTS trump_tweet_megatable;
CREATE TABLE IF NOT EXISTS trump_tweet_megatable (
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
user_location VARCHAR(8000) DEFAULT NULL, 
lat VARCHAR(255) DEFAULT NULL,
lon VARCHAR(255) DEFAULT NULL,
city VARCHAR(255) DEFAULT NULL,
country VARCHAR(255) DEFAULT NULL,
continent VARCHAR(255) DEFAULT NULL,
state VARCHAR(255) DEFAULT NULL,
state_code VARCHAR(255) DEFAULT NULL,
collected_at VARCHAR(255) DEFAULT NULL
) ENGINE = INNODB;

LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_donaldtrump.csv'
INTO TABLE trump_tweet_megatable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;
