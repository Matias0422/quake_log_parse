# Quake Log Parser

### About

The Quake Log Parser project parses a Quake 3 game log file and generates a report for each match. Below is an example of a generated report:

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

### Running Locally using Docker

#### Prerequisites

Before running the project locally, ensure you have the following installed:

- Docker
- Make

#### Step 1: Create .env.local File

Create a `.env.local` file in the root directory of your project based on the provided `.env.local.example` file.

```bash
cp .env.local.example .env.local
```

Edit the .env file and set the values according to your requirements:

```env
LOG_FILE_NAME=logfile.txt
LINES_BATCH_NUMBER=100
```
#### Step 2:Place Your Log File in the Root of the Project

Ensure your log file is placed in the root directory of the project with the name specified in the `LOG_FILE_NAME` environment variable.

#### Step 3: Build the Docker Image

Set the Build the Docker image:

```bash
make setup
```

#### Step 5: Run the Docker Container

Run the Docker container to start the parser:

```bash
make run-local
```

If you want to run the RSpec tests:

```bash
make run-test
```
