# Quake Log Parser

### About

This project parses a Quake 3 game log file and print a report of each Match.
A example of a report can be seen bellow: 

```ruby
{
    :game_21 => {
            :parse_state => "FINISHED",
            :total_kills => 131,
                :players => [
            [0] "Isgalamido",
            [1] "Oootsimo",
            [2] "Dono da Bola",
            [3] "Assasinu Credi",
            [4] "Zeh",
            [5] "Mal"
        ],
                  :kills => {
                  :Isgalamido => 19,
                    :Oootsimo => 24,
              :"Dono da Bola" => 16,
            :"Assasinu Credi" => 22,
                         :Zeh => 21,
                         :Mal => 12
        },
        :players_ranking => {
                    :Oootsimo => 22,
            :"Assasinu Credi" => 19,
                         :Zeh => 19,
                  :Isgalamido => 17,
              :"Dono da Bola" => 14,
                         :Mal => 6
        },
         :kills_by_means => {
                       :MOD_BFG => 0,
                :MOD_BFG_SPLASH => 0,
                  :MOD_CHAINGUN => 0,
                     :MOD_CRUSH => 0,
                   :MOD_FALLING => 3,
                  :MOD_GAUNTLET => 0,
                   :MOD_GRAPPLE => 0,
                   :MOD_GRENADE => 0,
            :MOD_GRENADE_SPLASH => 0,
                    :MOD_JUICED => 0,
                  :MOD_KAMIKAZE => 0,
                      :MOD_LAVA => 0,
                 :MOD_LIGHTNING => 0,
                :MOD_MACHINEGUN => 4,
                      :MOD_NAIL => 0,
                    :MOD_PLASMA => 0,
             :MOD_PLASMA_SPLASH => 0,
            :MOD_PROXIMITY_MINE => 0,
                   :MOD_RAILGUN => 9,
                    :MOD_ROCKET => 37,
             :MOD_ROCKET_SPLASH => 60,
                   :MOD_SHOTGUN => 4,
                     :MOD_SLIME => 0,
                   :MOD_SUICIDE => 0,
              :MOD_TARGET_LASER => 0,
                  :MOD_TELEFRAG => 0,
              :MOD_TRIGGER_HURT => 14,
                   :MOD_UNKNOWN => 0,
                     :MOD_WATER => 0
        }
    }
}
```

### Running Locally

#### Step 1: Prerequisites

Before you begin, ensure that you have Docker installed on your system. You can download and install Docker from the official Docker website: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

#### Step 2: Clone the Repository

Clone the repository containing the Dockerfile, your Ruby script, and the `.env.example` file:

```bash
git clone <repository-url>
cd <repository-directory>
```

#### Step 3: Create .env File

Create a `.env` file in the root directory of your project based on the provided `.env.example` file. Update the values of `LOG_FILE_PATH` and `LINES_BATCH_NUMBER` as needed.

```bash
cp .env.local.example .env.local
```

Edit the .env file and set the values according to your requirements:

```env
LOG_FILE_NAME=logfile.txt
LINES_BATCH_NUMBER=100
```
You need to place the log file in the root of the project.

#### Step 4: Build the Docker Image

Build the Docker image:

```bash
make setup
```

#### Step 5: Run the Docker Container

Run the Docker container:

```bash
make run-local
```

If you want to run the rspec tests:

```bash
make run-test
```
