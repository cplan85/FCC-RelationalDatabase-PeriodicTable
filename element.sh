#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

FIRST_ARGUMENT=$1

# Function to extract element information
EXTRACT_ELEMENT_INFO() {
    local ELEMENT_INFO="$1"
    IFS="|" read -ra elements <<< "$ELEMENT_INFO"
    local name="${elements[0]}"
    local symbol="${elements[1]}"
    local type="${elements[2]}"
    local atomic_mass="${elements[3]}"
    local melting_point_celsius="${elements[4]}"
    local boiling_point_celsius="${elements[5]}"
    local atomic_number="${elements[6]}"

    # TODO IF ELEMENT INFO IS A NUMBER THEN
    echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
}

MAIN_MENU() {
    LOCAL_FIRST_ARGUMENT=$FIRST_ARGUMENT


  if echo "$LOCAL_FIRST_ARGUMENT" | egrep -q '^[0-9]+$';
  then

 ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius, elements.atomic_number FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number 
 FULL JOIN types ON properties.type_id = types.type_id
 WHERE elements.atomic_number=$LOCAL_FIRST_ARGUMENT")  

 EXTRACT_ELEMENT_INFO "$ELEMENT_INFO"

else 

      # Check if it's a single or double letter
      if [[ "$LOCAL_FIRST_ARGUMENT" =~ ^[a-zA-Z]{1,2}$ ]]; then
          # GET ELEMENT BY SYMBOL
          ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius, elements.atomic_number FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number
          FULL JOIN types ON properties.type_id = types.type_id
          WHERE elements.symbol='$LOCAL_FIRST_ARGUMENT'");  

          EXTRACT_ELEMENT_INFO "$ELEMENT_INFO"
          
      else
          #  GET ELEMENT BY NAME
          ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius, elements.atomic_number FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number 
          FULL JOIN types ON properties.type_id = types.type_id
          WHERE elements.name='$LOCAL_FIRST_ARGUMENT'");

          if [[ -z $ELEMENT_INFO ]]
            then 
            echo -e "I could not find that element in the database."
            # TODO IF ELEMENT_INFO IS NULL THEN PROVIDE DEFAULT STATEMENT
            else 
            EXTRACT_ELEMENT_INFO "$ELEMENT_INFO"
            fi

      fi


  fi

}

if [[ -z $FIRST_ARGUMENT ]]
            then 
            echo -e "Please provide an element as an argument."
            # TODO IF ELEMENT_INFO IS NULL THEN PROVIDE DEFAULT STATEMENT
            # read USER_INPUT
            # echo $USER_INPUT
            # MAIN_MENU "$USER_INPUT"
            else
            MAIN_MENU
            fi

