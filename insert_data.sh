#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # ====================== INSERT BOTH TEAMS INTO teams TABLE ======================
  if [[ $YEAR != year ]]
  then
    # get winner team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert winner team
      TEAM_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $TEAM_INSERT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi
    fi

    # get opponent team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert opponent team
      TEAM_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $TEAM_INSERT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
    fi
    # ======================== INSERT GAMES INTO teams TABLE =========================

    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert game
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $GAME_INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi
done
