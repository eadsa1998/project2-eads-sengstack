<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

    // $var_tweet_id = $_POST['f_tweet_id'];
    $var_user_id = $_POST['f_user_id'];
    $var_created_at = $_POST['f_created_at'];
    $var_collected_at = $_POST['f_collected_at'];
    $var_source = $_POST['f_source'];
    $var_tweet = $_POST['f_tweet'];
    $var_likes = $_POST['f_likes'];
    $var_retweet_count = $_POST['f_retweet_count'];
    $var_total_popularity = $_POST['f_total_popularity'];
    $var_candidate = $_POST['f_candidate'];
    $var_tweet_ratio = $_POST['f_tweet_ratio'];

    $query = "INSERT INTO tweet_info (tweet_id, user_id, created_at, collected_at, source, tweet, likes, retweet_count, total_popularity, candidate, tweet_ratio)"
             . "VALUES (DEFAULT, :user_id, :created_at, :collected_at, :source, :tweet, :likes, :retweet_count, :total_popularity, :candidate, :tweet_ratio)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      // $prepared_stmt->bindValue(':tweet_id', $var_tweet_id, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':user_id', $var_user_id, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':created_at', $var_created_at, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':collected_at', $var_collected_at, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':source', $var_source, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':tweet', $var_tweet, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':likes', $var_likes, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':retweet_count', $var_retweet_count, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':total_popularity', $var_total_popularity, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':candidate', $var_candidate, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':tweet_ratio', $var_tweet_ratio, PDO::PARAM_INT);
      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}

?>

<html>
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" type="text/css" href="project.css" />
  </head> 

  <body>
    <div id="navbar">
      <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="getTweet.php">Search For A Tweet</a></li>
        <li><a href="insertTweet.php">Insert Tweet</a></li>
        <li><a href="deleteTweet.php">Delete Tweet</a></li>
	<li><a href="getState.php">Search By State</a></li>
	<li><a href="https://public.tableau.com/profile/ashley.eads#!/vizhome/2020ElectionTweetsDatabase/MapofVotesByCandidate?publish=yes">Tableau Graphs</a></li>
      </ul>
    </div>

<h1> Insert Tweet </h1>

    <form method="post">
    	<label for="id_user_id">User Id</label>
    	<input type="text" name="f_user_id" id="id_user_id">

    	<label for="id_created_at">Created At</label>
    	<input type="text" name="f_created_at" id="id_created_at">

    	<label for="id_collected_at">Collected At</label>
    	<input type="text" name="f_collected_at" id="id_collected_at">

	<label for="id_source">Source</label>
    	<input type="text" name="f_source" id="id_source">

	<label for="id_tweet">Tweet</label>
    	<input type="text" name="f_tweet" id="id_tweet">

	<label for="id_likes">Likes</label>
    	<input type="text" name="f_likes" id="id_likes">

	<label for="id_retweet_count">Retweet Count</label>
    	<input type="text" name="f_retweet_count" id="id_retweet_count">

	<label for="id_total_popularity">Total Popularity</label>
    	<input type="text" name="f_total_popularity" id="id_total_popularity">

	<label for="id_candidate">Candidate</label>
    	<input type="text" name="f_candidate" id="id_candidate">

	<label for="id_tweet_ratio">Tweet Ratio</label>
    	<input type="text" name="f_tweet_ratio" id="id_tweet_ratio">
    	
    	<input type="submit" name="f_submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['f_submit'])) {
        if ($result) { 
    ?>
          Tweet data was inserted successfully.
    <?php 
        } else { 
    ?>
          <h3> Sorry, there was an error. Tweet data was not inserted. </h3>
    <?php 
        }
      } 
    ?>


    
  </body>
</html>
