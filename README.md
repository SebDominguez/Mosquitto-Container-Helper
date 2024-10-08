# Mosquitto-Docker-Helper

A Bash script to help manage Mosquitto containers, including creating, listing, and deleting Mosquitto users, as well as handling Docker Compose operations like starting, stopping, and updating the container.

---

## Features

- **Start/Stop/Restart** Mosquitto container with Docker Compose
- **Update** Mosquitto container by pulling the latest image
- **Create Mosquitto Users** with a username and password
- **List Mosquitto Users** from the Mosquitto password file
- **Delete Mosquitto Users** from the Mosquitto password file
- Docker Compose version detection

## Usage

### Available Commands
```bash
./mosquitto_helper.sh [command]
```

| Command       | Description                                         |
|---------------|-----------------------------------------------------|
| `start`       | Starts the Mosquitto container                      |
| `stop`        | Stops the Mosquitto container                       |
| `restart`     | Restarts the Mosquitto container                    |
| `update`      | Updates the Mosquitto container (pulls latest image)|
| `createuser`  | Adds a new Mosquitto user with username and password|
| `listusers`   | Lists all Mosquitto users                           |
| `deleteuser`  | Deletes a Mosquitto user by username                |
| `help`        | Displays the list of available commands             |

---

### How to Install



1. Clone the repository:

```bash
git clone https://github.com/SebDominguez/mosquitto-docker-helper.git
```

Or download the script and the docker-compose file directly:

```bash
curl -O https://raw.githubusercontent.com/SebDominguez/Mosquitto-Container-Helper/refs/heads/master/mosquitto.sh -O https://raw.githubusercontent.com/SebDominguez/Mosquitto-Container-Helper/refs/heads/master/docker-compose.yml
```

2. Make the script executable:

```bash
chmod +x mosquitto_helper.sh
```

3. Ensure `docker-compose` is installed on your system. The script will automatically detect whether to use `docker-compose` or the `docker compose` command.

---

### How to Use

#### Start Mosquitto Container
```bash
./mosquitto_helper.sh start
```

#### Create a Mosquitto User
```bash
./mosquitto_helper.sh createuser
```

You will be prompted to enter the username and password for the new Mosquitto user.

#### List All Mosquitto Users
```bash
./mosquitto_helper.sh listusers
```

#### Delete a Mosquitto User
```bash
./mosquitto_helper.sh deleteuser <username>
```

Replace `<username>` with the actual username you wish to delete.

#### Update the Mosquitto Container
```bash
./mosquitto_helper.sh update
```

This will pull the latest image and restart the container.

---

### Configuration

By default, the script expects the following folder structure:

- `./config/` - The local directory where the Mosquitto configuration is stored.
- `passwordfile` - The file where Mosquitto stores user credentials.

If these paths need to be adjusted, modify the `LOCAL_CONFIG` and `CONTAINER_CONFIG` variables in the script.

---

### Contributions

Feel free to submit issues or pull requests if you'd like to improve the script or add new features.

---

### License

None

---

### Author

**Sébastien Dominguez**

GitHub: [SebDominguez](https://github.com/SebDominguez)

---

Let me know if you'd like any additional changes or further refinements!
