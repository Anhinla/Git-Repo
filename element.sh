#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then 
  ATOMIC_ID=-1
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    ATOMIC_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  elif [[ $1 =~ ^[A-Za-z]+$ ]]
  then 
    ATOMIC_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    if [[ -z $ATOMIC_ID ]]
    then
      ATOMIC_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    fi
  fi

  if [[ $ATOMIC_ID != -1 && ! -z $ATOMIC_ID ]]
  then 
    ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_ID")
    ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_ID")
    PROPETIES_RES=$($PSQL "select * from properties where atomic_number=$ATOMIC_ID")
    TYPE_ID=$($PSQL "select type_id from properties where atomic_number=$ATOMIC_ID")
    TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")
    ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_ID")
    MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_ID")
    BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_ID")
    echo "The element with atomic number $ATOMIC_ID is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else 
    echo "I could not find that element in the database."
  fi
else 
  echo "Please provide an element as an argument."
fi
