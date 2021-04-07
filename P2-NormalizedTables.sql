# In this SQL script we will create populate decomposed tables with info from the mega table.
USE election_tweets;

# Create the table for each specific tweet
DROP TABLE IF EXISTS tweet_info;
CREATE TABLE IF NOT EXISTS tweet_info (
tweet_id INT UNSIGNED AUTO_INCREMENT,
user_id BIGINT UNSIGNED NOT NULL,
created_at VARCHAR(255) DEFAULT NULL,
collected_at VARCHAR(255) DEFAULT NULL,
source VARCHAR(255) DEFAULT NULL,
tweet VARCHAR(8000) DEFAULT NULL,
likes INT UNSIGNED NOT NULL,
retweet_count INT UNSIGNED NOT NULL,
total_popularity INT UNSIGNED, 
candidate VARCHAR (30),
tweet_ratio FLOAT,
PRIMARY KEY (tweet_id),
CONSTRAINT fk_user_info FOREIGN KEY (user_id)
		REFERENCES election_tweets.user_info (user_id)
        ON UPDATE CASCADE
		ON DELETE NO ACTION,
CONSTRAINT fk_user_location FOREIGN KEY (user_id)
		REFERENCES election_tweets.user_location (user_id)
        ON UPDATE CASCADE
		ON DELETE NO ACTION,
CONSTRAINT fk_candidate FOREIGN KEY (candidate)
		REFERENCES election_tweets.election_results (candidate)
        ON UPDATE CASCADE
		ON DELETE NO ACTION 
);

# Populate the tweet info table
INSERT INTO tweet_info
SELECT tweet_id, user_id, created_at, collected_at, source, tweet, likes, retweet_count, total_popularity, candidate, tweet_ratio
FROM election_tweets.tweet_megatable;

# Create the table for user info
DROP TABLE IF EXISTS user_info;
CREATE TABLE IF NOT EXISTS user_info (
user_id BIGINT UNSIGNED NOT NULL,
user_name VARCHAR(500) DEFAULT NULL,
user_screen_name VARCHAR(255) DEFAULT NULL,
user_description VARCHAR(8000) DEFAULT NULL,
user_join_date VARCHAR(255) DEFAULT NULL,
user_followers_count VARCHAR (255) DEFAULT NULL,
PRIMARY KEY (user_id)
);

# Populate the user info table
INSERT INTO user_info
SELECT user_id, user_name, user_screen_name, user_description, user_join_date, user_followers_count
FROM election_tweets.tweet_megatable
GROUP BY user_id;

#Create the table for location info
DROP TABLE IF EXISTS user_location;
CREATE TABLE IF NOT EXISTS user_location (
user_id BIGINT UNSIGNED NOT NULL,
user_location VARCHAR(8000) DEFAULT NULL, 
lat VARCHAR(255) DEFAULT NULL,
lon VARCHAR(255) DEFAULT NULL,
city VARCHAR(255) DEFAULT NULL,
country VARCHAR(255) DEFAULT NULL,
continent VARCHAR(255) DEFAULT NULL,
state VARCHAR(255) DEFAULT NULL,
state_code VARCHAR(255) DEFAULT NULL,
PRIMARY KEY (user_id),
CONSTRAINT fk_state FOREIGN KEY (state)
		REFERENCES election_tweets.election_results (state)
        ON UPDATE CASCADE
		ON DELETE NO ACTION 
);

# Populate the user location table
INSERT INTO user_location
SELECT user_id, user_location, lat, lon, city, country, continent, state, state_code
FROM election_tweets.tweet_megatable
GROUP BY user_id;

# Create the election results table
DROP TABLE IF EXISTS election_results;
CREATE TABLE IF NOT EXISTS election_results (
state VARCHAR(30),
county VARCHAR(30),
candidate VARCHAR(30),
total_votes INT UNSIGNED,
won_race VARCHAR(30),
PRIMARY KEY (state, county, candidate),
CONSTRAINT fk_candidate_party FOREIGN KEY (candidate)
		REFERENCES election_tweets.candidate_party (candidate)
        ON UPDATE CASCADE
		ON DELETE NO ACTION 
);

# Create the candidate party table
DROP TABLE IF EXISTS candidate_party;
CREATE TABLE IF NOT EXISTS candidate_party (
candidate VARCHAR(30),
party VARCHAR(5),
PRIMARY KEY (candidate)
);

# Load data into election_results table
INSERT INTO election_results
SELECT state, county, candidate, total_votes, won_race
FROM election_results_megatable
WHERE candidate = "Joe Biden" OR candidate = "Donald Trump";

# Load data into candidate party table
INSERT INTO candidate_party
SELECT candidate, party 
FROM election_results_megatable
GROUP BY candidate
HAVING candidate = "Joe Biden" OR candidate = "Donald Trump";