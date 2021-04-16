  
# This SQL code will contain the advanced features for our database
# We are again going to use the election_tweets database we created for our advanced features
USE election_tweets;

# Views
# Create a view to see the number of votes in each state
DROP VIEW IF EXISTS votes_by_state;
CREATE VIEW total_votes_by_state AS
SELECT state, candidate, SUM(total_votes) AS total_votes, won_race
FROM election_results
GROUP BY state, candidate;

# Create a view to show the percentage of votes in each state
DROP VIEW IF EXISTS percent_votes_by_state;
CREATE VIEW percent_votes_by_state AS
SELECT state, candidate, ((total_votes/state_total) * 100) AS percent_votes_won, won_race
FROM (SELECT state, candidate, SUM(total_votes) AS total_votes, state_total, won_race
	  FROM election_tweets.election_results
		LEFT JOIN (SELECT state, SUM(total_votes) AS state_total
				   FROM (SELECT state, candidate, SUM(total_votes) AS total_votes
						 FROM election_tweets.election_results
					     GROUP BY state, candidate) AS total_votes_by_state
					     GROUP BY state) AS state_totals USING (state)
	  GROUP BY state, candidate) AS state_calc_table;

# Stored procedures
# Create a stored procedure that takes in a state and returns the number of tweets about each candidate in the specified state
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


# Create a stored procedure to find the number of tweets above a certian popularity threshold for each candidate
DROP PROCEDURE IF EXISTS tweet_popularity;
DELIMITER //
CREATE PROCEDURE tweet_popularity(IN popularity_threshold INT UNSIGNED)
BEGIN
    SELECT candidate, COUNT(*) AS tweets_above_threshold
	FROM tweet_info
	WHERE total_popularity >= popularity_threshold
    GROUP BY candidate;
END //
    
DELIMITER ; 

# Call tweet_popularity
CALL tweet_popularity(1000);


# Now let's write the stored procedure where we can compare the vote percentage and tweet percentage by for a given state
DROP PROCEDURE IF EXISTS percentageComp;
DELIMITER //
CREATE PROCEDURE percentageComp(IN desired_state VARCHAR (50))
BEGIN
	SELECT state, candidate, total_votes, number_of_tweets, ((total_votes/state_total_votes) * 100) AS percent_vote, ((number_of_tweets/state_total_tweets) * 100) AS percent_tweets
	FROM (SELECT state, candidate, SUM(total_votes) AS total_votes, number_of_tweets    
		  FROM election_tweets.election_results 
		       LEFT JOIN (SELECT state, candidate, COUNT(*) AS number_of_tweets
				          FROM election_tweets.tweet_info JOIN
						       election_tweets.user_location USING (user_id)
						  WHERE state = desired_state
				          GROUP BY state, candidate) AS candidate_tweets_by_state USING (state, candidate)
	 WHERE state = desired_state
	 GROUP BY state, candidate) AS tweets_votes
		LEFT JOIN (SELECT state, SUM(total_votes) AS state_total_votes, SUM(number_of_tweets) AS state_total_tweets
				   FROM (SELECT state, candidate, SUM(total_votes) AS total_votes, number_of_tweets    
					     FROM election_tweets.election_results 
							LEFT JOIN (SELECT state, candidate, COUNT(*) AS number_of_tweets
									   FROM election_tweets.tweet_info JOIN
										 election_tweets.user_location USING (user_id)
									   WHERE state = desired_state
									   GROUP BY state, candidate) AS candidate_tweets_by_state USING (state, candidate)
						 WHERE state = desired_state
						 GROUP BY state, candidate) AS tweets_votes
					GROUP BY state) AS state_overall USING (state);
END //
    
DELIMITER ; 

# Now we need to test our procedure on California
CALL percentageComp("California");


# Include deleteTweet procedure for the delete a tweet UI page
DROP PROCEDURE IF EXISTS deleteTweet;
DELIMITER //
CREATE PROCEDURE deleteTweet(IN desired_tweet VARCHAR (8000))
BEGIN
    DELETE FROM election_tweets.tweet_info
	WHERE tweet = desired_tweet;
END //
    
DELIMITER ; 


# Triggers
# These triggers update the total popularity variable when either the retweet count or the likes count is updated

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

