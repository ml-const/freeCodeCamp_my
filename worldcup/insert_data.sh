#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "SELECT * FROM teams")	
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $YEAR != "year" ]]
	then
		#echo "Read teams $OPPONENT "
		# get major_id
		NUMBER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		if  [[ -z $NUMBER  ]]
		then
				INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
				WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		else
				WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		fi
		if [[ $INSERT_TEAM == "INSERT 0 1" ]]
  	then
  			echo "Inserted winner into teams $WINNER ID $WINNER_ID"
 		fi
		NUMBER=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		if [[ -z $NUMBER ]]
		then
				INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
				OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		else
				OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		fi
		if [[ $INSERT_TEAM == "INSERT 0 1" ]]
  	then
  			echo "Inserted opponent into teams $OPPONENT, ID $OPPONENT_ID"
 		fi
		
		INSERT_LINE=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
													VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
		if [[ $INSERT_LINE == "INSERT 0 1" ]]
  	then
  			echo "Inserted opponent into teams $YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS"
 		fi
		#else
		#	echo "Find $NUMBER"
		
	fi
done
