#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

INSERT_TEAMS(){
  SEARCH_TEAM=$($PSQL "select * from teams where name='$1'")
  if [[ -z $SEARCH_TEAM ]]; then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$1')")
      echo $INSERT_TEAM team inserted.
  fi
}

DELETE_RECORDS=$($PSQL "truncate teams, games")
echo $DELETE_RECORDS, records have been deleted.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]; then
    INSERT_TEAMS "$WINNER"
    INSERT_TEAMS "$OPPONENT"
  fi

  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  echo $INSERT_GAMES game inserted.

done