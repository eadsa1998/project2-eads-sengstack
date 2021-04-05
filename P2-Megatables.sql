-- Create Database Statement
DROP DATABASE IF EXISTS election_tweets;
CREATE DATABASE IF NOT EXISTS election_tweets ;

USE election_tweets;

-- Create table to load in Biden tweet data
DROP TABLE IF EXISTS biden_tweet_loadintable;
CREATE TABLE IF NOT EXISTS biden_tweet_loadintable (
created_at VARCHAR(255) DEFAULT NULL,
tweet_id INT UNSIGNED NOT NULL,
tweet VARCHAR(8000) DEFAULT NULL,
likes INT UNSIGNED NOT NULL,
retweet_count INT UNSIGNED NOT NULL,
source VARCHAR(255) DEFAULT NULL,
user_id BIGINT UNSIGNED NOT NULL,
user_name VARCHAR(8000) DEFAULT NULL,
user_screen_name VARCHAR(255) DEFAULT NULL,
user_description VARCHAR(8000) DEFAULT NULL,
user_join_date VARCHAR(255) DEFAULT NULL,
user_followers_count INT UNSIGNED NOT NULL,
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

# Load in the Biden tweet data 
LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_joebiden.csv'
IGNORE INTO TABLE biden_tweet_loadintable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;

-- Create table to load in Trump tweet data
DROP TABLE IF EXISTS trump_tweet_loadintable;
CREATE TABLE IF NOT EXISTS trump_tweet_loadintable (
created_at VARCHAR(255) DEFAULT NULL,
tweet_id INT UNSIGNED NOT NULL,
tweet VARCHAR(8000) DEFAULT NULL,
likes INT UNSIGNED NOT NULL,
retweet_count INT UNSIGNED NOT NULL,
source VARCHAR(255) DEFAULT NULL,
user_id BIGINT NOT NULL,
user_name VARCHAR(8000) DEFAULT NULL,
user_screen_name VARCHAR(255) DEFAULT NULL,
user_description VARCHAR(8000) DEFAULT NULL,
user_join_date VARCHAR(255) DEFAULT NULL,
user_followers_count INT UNSIGNED DEFAULT NULL,
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

# Load in the trump tweet data
LOAD DATA INFILE 'C:\\wamp64\\tmp\\hashtag_donaldtrump.csv'
IGNORE INTO TABLE trump_tweet_loadintable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;

-- Create table to load in election result data
DROP TABLE IF EXISTS election_results_megatable;
CREATE TABLE IF NOT EXISTS election_results_megatable (
state VARCHAR(255) DEFAULT NULL,
county VARCHAR(255) DEFAULT NULL,
candidate VARCHAR(8000) DEFAULT NULL,
party VARCHAR(255) DEFAULT NULL,
total_votes INT UNSIGNED,
won_race VARCHAR(255) DEFAULT NULL
) ENGINE = INNODB;

# Load in the election results data
LOAD DATA INFILE 'C:\\wamp64\\tmp\\president_county_candidate.csv'
INTO TABLE election_results_megatable
FIELDS TERMINATED BY ','
	   ENCLOSED BY '"'
       ESCAPED BY '\\'
IGNORE 1 LINES;

-- Create Mega table for all tweets
DROP TABLE IF EXISTS tweet_megatable;
CREATE TABLE IF NOT EXISTS tweet_megatable (
created_at VARCHAR(255) DEFAULT NULL,
tweet_id INT UNSIGNED NOT NULL,
tweet VARCHAR(8000) DEFAULT NULL,
likes VARCHAR(255) DEFAULT NULL,
retweet_count VARCHAR(255) DEFAULT NULL,
source VARCHAR(255) DEFAULT NULL,
user_id VARCHAR(255) NOT NULL,
user_name VARCHAR(8000) DEFAULT NULL,
user_screen_name VARCHAR(255) DEFAULT NULL,
user_description VARCHAR(8000) DEFAULT NULL,
user_join_date VARCHAR(255) DEFAULT NULL,
user_followers_count VARCHAR (255) DEFAULT NULL,
user_location VARCHAR(8000) DEFAULT NULL, 
lat VARCHAR(255) DEFAULT NULL,
lon VARCHAR(255) DEFAULT NULL,
city VARCHAR(255) DEFAULT NULL,
country VARCHAR(255) DEFAULT NULL,
continent VARCHAR(255) DEFAULT NULL,
state VARCHAR(255) DEFAULT NULL,
state_code VARCHAR(255) DEFAULT NULL,
collected_at VARCHAR(255) DEFAULT NULL,
total_popularity INT UNSIGNED, 
candidate VARCHAR (30),
tweet_ratio FLOAT
);

# Insert Biden info into the tweet mega table

INSERT INTO tweet_megatable
SELECT *, (likes + retweet_count) AS total_popularity, "Biden" AS tweet_candidate, 
CASE
    WHEN retweet_count = 0 THEN likes/1 
    ELSE likes/retweet_count
END AS tweet_ratio
FROM election_tweets.biden_tweet_loadintable;


# Insert trump info into the tweet mega table. 
INSERT INTO tweet_megatable
SELECT created_at, (tweet_id + 1048491) AS tweet_id, tweet, likes, retweet_count, source, user_id, user_name, user_screen_name, user_description, user_join_date, user_followers_count, user_location, lat, lon, city, country, continent, state, state_code, collected_at, (likes + retweet_count) AS total_popularity, "Trump" AS tweet_candidate, 
CASE
    WHEN retweet_count = 0 THEN likes/1 
    ELSE likes/retweet_count
END AS tweet_ratio
FROM election_tweets.trump_tweet_loadintable;


