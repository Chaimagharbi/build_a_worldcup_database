#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
cat games.csv | while IFS="," read YEAR ROUND W O WG OG
do
  if [[ $W != "winner" ]]
  then
    #both winner and opponent are teams so winner_id,oppenent_id in team_id
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert winner_id
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$W') ")
    fi
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$O' ")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert opponent_id
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$O')")
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND W O WG OG
do
  if [[ $W != "winner" ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")
    #get opponet_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$O'")
    #insert row
    echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WG,$OG)")
  fi
done