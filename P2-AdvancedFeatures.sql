# This SQL file will contain the advanced features for our database
USE election_tweets;

# Views
DROP VIEW IF EXISTS votes_by_state;
CREATE VIEW votes_by_state AS
SELECT state, candidate, SUM(total_votes) AS total_votes, won_race
FROM election_results
GROUP BY state, candidate;

# Stored procedures
# find the number of tweets by candidate in each state
DROP PROCEDURE IF EXISTS tweetsByState;
DELIMITER //
CREATE PROCEDURE tweetsByState(IN desired_state VARCHAR (50))
BEGIN
    SELECT state, candidate, COUNT(*) AS number_of_tweets
	FROM election_tweets.tweet_info JOIN
		election_tweets.user_location USING (user_id)
	WHERE state = desired_state
	GROUP BY candidate;
END //
    
DELIMITER ; 

# Call tweetsByState
CALL tweetsByState("California");


# Triggers

DROP TRIGGER IF EXISTS retweet_update;
DELIMITER //
CREATE TRIGGER retweet_update
AFTER UPDATE
ON tweet_info
FOR EACH ROW
BEGIN
	
    IF NEW.retweet_count <> OLD.retweet_count THEN
		UPDATE tweet_info
        SET NEW.total_popularity = NEW.retweet_count + likes;
	END IF;
END //

DELIMITER ; 

DROP TRIGGER IF EXISTS retweet_update;
DELIMITER //
CREATE TRIGGER retweet_update
AFTER UPDATE
ON tweet_info
FOR EACH ROW
BEGIN
	
    IF NEW.retweet_count <> OLD.retweet_count THEN
		UPDATE tweet_info
        SET NEW.total_popularity = NEW.retweet_count + OLD.likes;
	END IF;
END //

DELIMITER ; 

DROP TRIGGER IF EXISTS likes_update;
DELIMITER //
CREATE TRIGGER likes_update
AFTER UPDATE
ON tweet_info
FOR EACH ROW
BEGIN
	
    IF NEW.likes <> OLD.likes THEN
		UPDATE tweet_info
        SET NEW.total_popularity = NEW.likes + OLD.retweet_count;
	END IF;
END //

DELIMITER ; 