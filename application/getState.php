<?php
// If the all the variables are set when the Submit button is clicked...
if (isset($_POST['field_submit'])) {
    // It will refer to conn.php file and will open a connection.
    require_once("conn.php");
    // Will get the value typed in the form text field and save into variable
    $var_state = $_POST['field_state'];
    // Save the query into variable called $query. Note that :title is a place holder
    $query = "CALL percentageComp(:state)";
    
    try
    {
      $prepared_stmt = $dbo->prepare($query);
      //bind the value saved in the variable $var_title to the place holder :title after //verifying (using PDO::PARAM_STR) that the user has typed a valid string.
      $prepared_stmt->bindValue(':state', $var_state, PDO::PARAM_STR);
      //Execute the query and save the result in variable named $result
      $prepared_stmt->execute();
       // Fetch all the values based on query and save that to variable $result
      $result = $prepared_stmt->fetchAll();


    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}

?>

<html>
  <!-- Any thing inside the HEAD tags are not visible on page.-->
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" type="text/css" href="project.css" />
  </head> 

  <!-- Everything inside the BODY tags are visible on page.-->
  <body>
     <!-- See the project.css file to see how is navbar stylized.-->
    <div id="navbar">
      <!-- See the project.css file to note how ul (unordered list) is stylized.-->
      <ul>
        <li><a href="index.html">Home</a></li> <!-- Link to Home page-->
        <li><a href="getTweet.php">Search For A Tweet</a></li> <!-- LInk to Search Movie page-->
        <li><a href="insertTweet.php">Insert Tweet</a></li>
        <li><a href="deleteTweet.php">Delete Tweet</a></li>
	<li><a href="getState.php">Search By State</a></li>
	<li><a href="https://public.tableau.com/profile/ashley.eads#!/vizhome/2020ElectionTweetsDatabase/MapofVotesByCandidate?publish=yes">Tableau Graphs</a></li>
      </ul>
    </div>
    <!-- See the project.css file to note h1 (Heading 1) is stylized.-->
    <h1> Search By State </h1>
    <!-- This is the start of the form. This form has one text field and one button.
      See the project.css file to note how form is stylized.-->
    <form method="post">

      <label for="id_state">State</label>
      <!-- The input type is a text field. Note the name and id. The name attribute
        is referred above on line 7. $var_title = $_POST['field_title']; -->
      <input type="text" name="field_state" id="id_state">
      <!-- The input type is a submit button. Note the name and value. The value attribute decides what will be dispalyed on Button. In this case the button shows Delete Movie.
      The name attribute is referred above on line 3 and line 63. -->
      <input type="submit" name="field_submit" value="Search For State">
    </form>

    <?php
      if (isset($_POST['field_submit'])) {
        if ($result) { 
    ?>
          State data was found successfully.
    <?php 
        } else { 
    ?>
          <h3> Sorry, there was an error. Could not find state data. </h3>
    <?php 
        }
      } 
    ?>

 <?php
      if (isset($_POST['field_submit'])) {
        // If the query executed (result is true) and the row count returned from the query is greater than 0 then...
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
              <!-- first show the header RESULT -->
              <h2>Results</h2>
              <!-- THen create a table like structure. See the project.css how table is stylized. -->
              <table>
                <!-- Create the first row of table as table head (thead). -->
                <thead>
                   <!-- The top row is table head with four columns named -- ID, Title ... -->
                  <tr>
                    <th>State</th>
                    <th>Candidate</th>
                    <th>Total Votes</th>
                    <th>Number of Tweets</th>
		    <th>Percent Vote</th>
		    <th>Percent Tweets</th>
                  </tr>
                </thead>
                 <!-- Create rest of the the body of the table -->
                <tbody>
                   <!-- For each row saved in the $result variable ... -->
                  <?php if (is_array($result))  
			foreach ($result as $row) { ?>
                
                    <tr>
                       <!-- Print (echo) the value of mID in first column of table -->
                      <td><?php echo $row["state"]; ?></td>
                      <!-- Print (echo) the value of title in second column of table -->
                      <td><?php echo $row["candidate"]; ?></td>
                      <!-- Print (echo) the value of movieYear in third column of table and so on... -->
                      <td><?php echo $row["total_votes"]; ?></td>
                      <td><?php echo $row["number_of_tweets"]; ?></td>
		      <td><?php echo $row["percent_vote"]; ?></td>
		      <td><?php echo $row["percent_tweets"]; ?></td>
                    <!-- End first row. Note this will repeat for each row in the $result variable-->
                    </tr>
                  <?php } ?>
                  <!-- End table body -->
                </tbody>
                <!-- End table -->
            </table>
  
        <?php } else { ?>
          <!-- IF query execution resulted in error display the following message-->
          <h3>Sorry, no results found for this state. <?php echo $_POST['field_state']; ?>. </h3>
        <?php }
    } ?>





    
  </body>
</html>
