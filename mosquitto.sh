#!/usr/bin/env bash
set -e

cat << "EOF"
                                 _ _   _        
 _ __ ___   ___  ___  __ _ _   _(_) |_| |_ ___  
| '_ ` _ \ / _ \/ __|/ _` | | | | | __| __/ _ \ 
| | | | | | (_) \__ \ (_| | |_| | | |_| || (_) |
|_| |_| |_|\___/|___/\__, |\__,_|_|\__|\__\___/ 
                        |_|                     
EOF

cat << EOF
Mosquitto Container Helper
v0.1 by Sébastien Dominguez
https://github.com/SebDominguez
===================================================

EOF

CYAN='\033[0;36m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Get the directory of the current script
DIR=$(dirname "$(readlink -f "$0")")

# Get the path of the docker-compose.yml file
COMPOSE_FILE=$DIR/docker-compose.yml

LOCAL_CONFIG=./config/
CONTAINER_CONFIG=/mosquitto/config/

PASSWD_FILE_NAME=passwd
LOCAL_PASSWORD_FILE="${LOCAL_CONFIG}${PASSWD_FILE_NAME}"
CONTAINER_PASSWORD_FILE="${CONTAINER_CONFIG}${PASSWD_FILE_NAME}"

if [ ! -f $LOCAL_PASSWORD_FILE ]; then
    echo "Password file not found. Creating $LOCAL_PASSWORD_FILE"

    touch $LOCAL_PASSWORD_FILE

    echo "Blank password file created"
fi

# Check if docker-compose exist. If it doesnt then we use docker compose instead
if command -v docker-compose &> /dev/null
then
    dccmd='docker-compose'
else
    dccmd='docker compose'
fi

function dockerComposeDown() {
    if [ $($dccmd ps | wc -l) -gt 2 ]; then
        $dccmd -f $COMPOSE_FILE down
    fi
}

# Functions
function restart() {
    dockerComposeDown
    dockerComposeUp
}

function dockerComposeUp() {
    $dccmd -f $COMPOSE_FILE up -d
}

function dockerPull() {
    $dccmd pull
}

function update() {
    dockerComposeDown
    dockerPull
    dockerComposeUp
}

function createUser(){
    docker exec --user root mosquitto chown root:root $CONTAINER_PASSWORD_FILE
    read -p "Enter the username for mosquitto_passwd: " username
    # Check if the username is not empty
    if [[ -z "$username" ]]; then
        echo "Error: Username cannot be empty."
        return 1
    fi
    # Prompt the user for a password
    read -sp "Enter the password for $username: " password
    echo

    # Check if the password is not empty
    if [[ -z "$password" ]]; then
        echo "Error: Password cannot be empty."
        exit 1
    fi
    # Use mosquitto_passwd to add the username and password in batch mode
    docker exec --user root mosquitto mosquitto_passwd -b $CONTAINER_PASSWORD_FILE $username $password 
}

function listUsers(){
    docker exec --user root mosquitto chown root:root $CONTAINER_PASSWORD_FILE
    # Check if the password file exists
    if [[ ! -f "$LOCAL_PASSWORD_FILE" ]]; then
        echo "Error: Password file does not exist at $LOCAL_PASSWORD_FILE"
        return 1
    fi
    # List the users by displaying the first field (username) of each line
    echo "Mosquitto users:"
    docker exec --user root mosquitto /usr/bin/cut -d ':' -f 1 "$CONTAINER_PASSWORD_FILE"
}

function deleteUser(){
    docker exec --user root mosquitto chown root:root $CONTAINER_PASSWORD_FILE
    docker exec --user root mosquitto mosquitto_passwd -D $CONTAINER_PASSWORD_FILE $1
    # Check the exit code
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to delete user $1."
    else
        echo "User $1 deleted successfully."
    fi
}

function listCommands() {
cat << EOT
Available commands:

start
stop
update
createuser
listuser
deleteuser
help

EOT
}

# Commands

case $1 in
    "start")
        dockerComposeUp
        ;;
    "update")
        update
        ;;
    "restart")
        restart
        ;;
    "stop")
        dockerComposeDown
        ;;
    "listusers")
        listUsers
        ;;
    "deleteuser")
        deleteUser "$2"
        ;;
    "createuser")
        createUser
        ;;
    "help")
        listCommands
        ;;
    *)
        echo "No command found."
        echo
        listCommands
esac
