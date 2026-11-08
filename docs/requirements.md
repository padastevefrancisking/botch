# Botch: System Requirements

Status: **Draft v0.1**. Covers everything outside the game rules: networking, the lobby,
the Storyteller's tools, movement and proximity voice. The game rules are in [rules.md](rules.md).

Each requirement has an ID. Reference it in issues, branch names and test names
(e.g. `test_net_05_late_joiner_spectates`). The **Acceptance** lines are written as
given/when/then so they can become tests directly.

---

## 1. Networking (NET)

| ID | Requirement |
| --- | --- |
| NET-01 | One player **hosts** a room. Everyone else joins it with a **room code**. |
| NET-02 | A room code is short (6 characters, letters and digits, no look-alikes such as `0/O` or `1/I`) and unique among open rooms. |
| NET-03 | Connections are **peer-to-peer**, with the host's game acting as the authority for game state (host-authoritative). |
| NET-04 | The host's copy of the game decides every rules outcome. Clients send requests (move, nominate, vote, use ability), and the host accepts or rejects them. |
| NET-05 | A player who joins a room **after the game has started** joins as a **spectator**. |
| NET-06 | When a player **disconnects mid-game**, they become Departed and win conditions are re-checked immediately (`RULE-40`). |
| NET-07 | A client only ever receives information that player is allowed to know. Other players' roles, night actions and Ledger notes are never sent to them. |
| NET-08 | If the **host** disconnects, the game ends for everyone and players are told why. (Host migration is out of scope for v1.) |
| NET-09 | Room size: up to 15 players + 1 Storyteller + spectators (spectator limit: 10, adjustable). |

**Acceptance**
- Given a room is open, when a player enters its code, then they join the lobby.
- Given an invalid or closed code, when a player enters it, then they see "Room not found" and stay on the join screen.
- Given a game in progress, when a new player joins, then they are a spectator and are not seated.
- Given a game in progress, when a seated player disconnects, then they are marked Departed and win conditions are checked.
- Given any client, when it receives game state, then it contains no role of any other living player (except evil players learning each other, `RULE-10`).

**Constraint to plan for:** across the internet, direct peer-to-peer usually needs help getting
through home routers (NAT). Room codes also need a small service that maps a code to the host.
Choosing that service (e.g. a WebRTC signalling server, or a relay) is a design decision for later.
It affects whether the web build on GitHub Pages can join games.

---

## 2. Lobby and setup (LOB)

| ID | Requirement |
| --- | --- |
| LOB-01 | The lobby shows the room code, seated players, the Storyteller and spectators. |
| LOB-02 | The host is the **Storyteller** by default and can hand the role to another person in the lobby. The Storyteller is not a player. |
| LOB-03 | The Start button is disabled while there are fewer than **5** or more than **15** players, with a message saying why (`RULE-01`). |
| LOB-04 | The Storyteller builds the bag. The UI shows the required team counts for the current player count (`RULE-03`), adjusted for setup modifiers such as the Patron (`RULE-07`), and blocks confirmation until they match. |
| LOB-05 | The bag cannot contain the same role twice (`RULE-04`). |
| LOB-06 | Players pick face-down tokens. A token disappears for everyone the moment it is picked, so no two players can pick it (`RULE-05`). |
| LOB-07 | When every player has a token, each player privately sees their role card. The Sleepwalker's card shows their **shown** role, and nothing on their screen hints otherwise (`RULE-08`). |

**Acceptance**
- Given 4 players, when the Storyteller presses Start, then the game does not start and the reason is shown.
- Given 7 players, when the Storyteller confirms a bag with 2 Strays, then confirmation is blocked (7 players need 1 Stray).
- Given 7 players and the Patron in the bag, when the bag has 3 Village and 2 Strays, then confirmation is allowed.
- Given the Sleepwalker is in the bag, when the Storyteller confirms it, then they must pick a shown role that chooses players and is not in the bag.
- Given a player picks the Sleepwalker token, then their role card shows the shown role, never "Sleepwalker".
- Given two players pick the same token at the same moment, then only the first request (as received by the host) gets it, and the other player picks again.

---

## 3. Storyteller and phases (ST)

| ID | Requirement |
| --- | --- |
| ST-01 | The Storyteller has a private **Ledger**: every player's role, alignment, statuses (dead, hexed, protected, ability used), and a notes field per player. For the Sleepwalker it shows both the real and the shown role. |
| ST-11 | When the Sleepwalker chooses a player, the Ledger asks the Storyteller which living neighbour to swap in before resolving the ability. |
| ST-02 | Each phase has a configurable **timer**, shown to everyone. |
| ST-03 | When the timer runs out, everyone sees "Time's up". The phase **does not change** until the Storyteller advances it (`RULE-13`). |
| ST-04 | The Storyteller can advance the phase **at any time**, with or without the timer having run out. |
| ST-05 | The Storyteller can pause, extend or reset the timer. |
| ST-06 | At night, the Storyteller steps through the **night order** (`rules.md` §8). For each role it shows who to wake and what they may choose, and records the result. |
| ST-07 | The Storyteller can send private info to one player (e.g. "2" for the Lamplighter) and make public announcements. |
| ST-08 | The Storyteller opens and closes nominations, and the vote count is computed automatically (`RULE-24`, `RULE-25`). |
| ST-09 | The Storyteller can end the game manually and choose the winner (`RULE-41`). |
| ST-10 | Every Storyteller action is written to a **game log**, which is shown to everyone after the game ends. |

**Acceptance**
- Given the day timer reaches 0, then all players see "Time's up" and the phase is still Day.
- Given the day timer has 2 minutes left, when the Storyteller advances, then the game moves to Night.
- Given the night order, when the Storyteller reaches a role that is not in play or is dead, then it is skipped.

---

## 4. Movement (MOVE)

| ID | Requirement |
| --- | --- |
| MOVE-01 | Top-down movement with **WASD**. Arrow keys also work. |
| MOVE-02 | Diagonal movement is the same speed as straight movement. |
| MOVE-03 | Players collide with walls and obstacles. They do not block each other. |
| MOVE-04 | Players can enter and leave **buildings** through doors. |
| MOVE-05 | During the **night**, players cannot move. Each player is placed in their own house at the start of the night. |
| MOVE-06 | The host is the authority on positions. Other players' movement looks smooth on each client. |
| MOVE-07 | Spectators move a free camera. They have no body in the world and cannot be seen or collided with. |
| MOVE-08 | Dead players can still move. They are shown as ghosts. |
| MOVE-09 | The **Storyteller has a character on the map**, visible to everyone and moved with the same controls. Unlike players, they can move during the night and can enter any building. |

**Acceptance**
- Given a player holds W and D, then they move diagonally at normal speed.
- Given it is night, when a player presses WASD, then they do not move.

---

## 5. Proximity voice chat (VOICE)

| ID | Requirement |
| --- | --- |
| VOICE-00 | There are three voice channels: **proximity voice**, for seated players (living or dead); the **Storyteller's voice**, heard by everyone (`VOICE-06`); and the **spectator channel**, for spectators only (`VOICE-12`). Spectators never use proximity voice. |
| VOICE-01 | Players hear each other by **distance**: full volume within **near range**, fading to silent at **far range**, and silent beyond it. Default: near = 4 tiles, far = 10 tiles, both adjustable. |
| VOICE-02 | Voices are **positional**: a voice to your left sounds from the left. |
| VOICE-03 | **Buildings block sound.** A player inside a building hears only people inside the same building. A player outside hears only people outside. Sound does not pass through walls in either direction. |
| VOICE-04 | The only exception to `VOICE-03` is the Eavesdropper (`rules.md` §7), and it is one-way: they hear through walls, but nobody hears them through walls, so nothing audible gives the role away. |
| VOICE-05 | During the **night**, players cannot hear each other. The Storyteller can speak privately to the player being woken. |
| VOICE-06 | The **Storyteller's voice is heard by everyone**: every player (living or dead) and every spectator, at full volume, anywhere on the map. It does not fade with distance and buildings do not block it. This is the Storyteller's normal way of speaking, by day and by night. |
| VOICE-07 | The Storyteller can switch to **private talk** with one player at any time. Only that player hears it. Other players and spectators do not, so secret information stays secret. |
| VOICE-13 | The Storyteller **hears players by proximity** from their character's position, using the same range and building rules as players (`VOICE-01`, `VOICE-03`). In private talk they also hear that player, wherever they are. They never hear spectators (`VOICE-09`). |
| VOICE-08 | Dead players talk normally (same proximity rules). |
| VOICE-09 | **Spectators** listen to players using the same proximity rules as players, measured from their camera position. They can never be heard by players or the Storyteller. |
| VOICE-12 | Spectators talk to each other on the **spectator channel**: every spectator hears every other spectator at **full volume**, with no distance fade and no building blocking. |
| VOICE-10 | Push-to-talk and open mic are both available. Each player can mute or adjust any other player's volume locally. |
| VOICE-11 | A small icon shows who is currently talking among the players you can hear. |

**Acceptance**
- Given two players 3 tiles apart outside, then each hears the other at full volume.
- Given two players 7 tiles apart outside, then each hears the other at partial volume.
- Given two players 12 tiles apart, then neither hears the other.
- Given one player inside a building and one just outside its wall, then neither hears the other.
- Given a spectator speaks, then no player and not the Storyteller hears them.
- Given two spectators with cameras at opposite ends of the map, when one speaks, then the other hears them at full volume.
- Given a spectator's camera is 3 tiles from a talking player, then the spectator hears that player at full volume.
- Given the Storyteller is inside a building, when they speak normally, then every player and spectator hears them at full volume.
- Given the Storyteller is in private talk with a player, then no other player and no spectator hears it.
- Given a player talks 12 tiles from the Storyteller's character, then the Storyteller does not hear them.

---

## 6. Out of scope for v1

- Host migration when the host leaves (`NET-08`).
- Text chat (could come later for accessibility).
- Custom role scripts or role editors.
- Matchmaking with strangers. v1 is room codes only.

---

## 7. Traceability

Every issue should name the requirement IDs it covers, and every test name should include one.
That way, searching for `VOICE-03` finds the rule, the issue, the PR and the tests.
