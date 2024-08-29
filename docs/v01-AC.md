# Acceptance Criteria

1. As a user, I can CREATE a game, and JOIN it right away with a provided username.
   1. `POST /api/v1/game`
   2. body `{ "username": "player1" }`
   3. response `201 Created { "game_id": 1 }`
   4. game
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "waiting",
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": false
            }
        ]
      }
      ```
2. As a user, I can JOIN an existing game with a provided username.
   1. `PUT /api/v1/game/:id/players`
   2. body `{ "username": "player2" }`
   3. response `204 No Content`
   4. game
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "waiting",
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": false
          },
          {
            "id": 2,
            "username": "player2",
            "ready": false
          }
        ]
      }
      ```
3. As a user, I can CHANGE myself to be READY or NOT READY if I am a player in the game.
   1. `PUT /api/v1/game/:id/ready`
   2. body `{ "username": "player1" }`
   3. response `204 No Content`
   4. game
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "waiting",
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": true
          },
          {
            "id": 2,
            "username": "player2",
            "ready": false
          }
        ]
      }
      ```
4. As a system, Game should START automatically when all players are READY.
   1. Given a game with 2 players, one is ready and the other is not ready.
   2. When not ready player changes to ready.
   3. Then the game should start.
   4. game
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "playing",
        "current_player_id": 1,
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": null,
            "role_card": null
          },
          {
            "id": 2,
            "username": "player2",
            "ready": null,
            "role_card": null
          }
        ]
      }
      ```
5. As a user, I can CHOOSE a role_card if is my turn. (use prospector as example)
   1. `POST /api/v1/game/:id/select-role_card`
   2. body `{ "username": "player1", "role_card": "prospector" }`
   3. response `204 No Content`
   4. game // player1 chosen prospector and ready to execute action
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "playing",
        "current_player_id": 1,
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": null,
            "role_card": "prospector"
          },
          {
            "id": 2,
            "username": "player2",
            "ready": null,
            "role_card": null
          }
        ]
      }
      ```
6. As a system, Game should END if game over condition is met.
   1. Given a game with 2 players, player1 selected prospector.
   2. When player1 execute prospector action.
   3. Then the game should end. (met the game over condition)
   4. game
      ```json
      {
        "id": 1,
        "name": "game_name",
        "status": "end",
        "current_player_id": null,
        "winner": null,
        "players": [
          {
            "id": 1,
            "username": "player1",
            "ready": null,
            "role_card": "prospector"
          },
          {
            "id": 2,
            "username": "player2",
            "ready": null,
            "role_card": null
          }
        ]
      }
      ```

## models

- Game
  - id: number (auto increment)
  - name: string
  - status: enum('waiting', 'playing', 'end')
  - current_player_id: number
  - winner: string
  - players: Player[]
- Player
  - id: number (auto increment)
  - username: string (unique)
- GamePlayer (join table)
  - id: composite key (game_id, player_id)
  - game_id: number
  - player_id: number
  - ready: boolean
  - role_card: enum('builder', 'producer', trader', 'councillor', 'prospector')
