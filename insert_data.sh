#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
tail -n +2 "games.csv" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
    # 插入获胜队伍到 teams 表
    $PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT (name) DO NOTHING;"
    # 插入对手队伍到 teams 表
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT (name) DO NOTHING;"
done

tail -n +2 "games.csv" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
    # 获取获胜队伍的 team_id
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    # 获取对手队伍的 team_id
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
    # 插入数据到 games 表
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
done
