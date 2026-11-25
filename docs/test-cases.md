# Botch: Test Cases

Status: **v0.1**. Covers only code that is implemented today. Features that are still stubs or
not started (e.g. `GameState.living_players`, night resolution, voting, win checks, lobby,
movement, voice) get test cases when they are built.

**Naming:** `test_<case id>_<req id>_<description>`. The requirement part is only there when
the case checks a rule from [rules.md](rules.md) or [requirements.md](requirements.md) (see
requirements.md §7). For example, `test_ut_player_08_rule_40_not_in_play_when_dead` is case
UT-PLAYER-08 and backs RULE-40. Searching for either ID finds the case here and the code in
`test/`. The **Req** column lists the requirement, or a section (§) for context only.

**Layers** follow the README: `test/unit` is pure logic with no scene tree,
`test/integration` puts nodes or scenes in the tree, and `test/e2e` boots the main scene.

Tests are role-agnostic: they build players from made-up fixture roles
(`test/support/fixtures.gd`), not from the real role list.

**Result legend:** Pass · Fail (reason) · Not run

How to run (from the project folder):

```powershell
& "D:\GameDev\Godot Releases\Releases\Godot_v4.6.3-stable_win64.exe\Godot_v4.6.3-stable_win64_console.exe" --headless -s addons/gut/gut_cmdln.gd -gdir=res://test/unit
```

Swap `test/unit` for `test/integration` or `test/e2e` to run the other layers.

---

## 1. Unit tests (`test/unit`)

Pure logic, no scene tree.

### 1.1 Teams (`constants/players/teams.gd`): `test/unit/constants/test_teams.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-TEAM-01 | §1 | Good teams are not evil | Call `Teams.is_evil` with `TOWNSFOLK`, then `OUTSIDER` | Returns `false` for both | Pass |
| UT-TEAM-02 | §1 | Evil teams are evil | Call `Teams.is_evil` with `MINION`, then `DEMON` | Returns `true` for both | Pass |
| UT-TEAM-03 | | Team id format | Call `Teams.get_id` for every `Kind` | Returns `TEAM_` + the upper-case kind name (e.g. `TEAM_MINION`) | Pass |
| UT-TEAM-04 | | Team ids are unique | Collect `get_id` for every `Kind` | No two kinds share an id | Pass |
| UT-TEAM-05 | | Team id is a StringName | Call `Teams.get_id(TOWNSFOLK)` | Return type is `StringName` | Pass |

### 1.2 Role ids (`constants/players/roles.gd`): `test/unit/constants/test_roles.gd`

Generic checks on the id list only, no role behaviour.

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-ROLEID-01 | | Ids are not empty | Read every constant in `Roles` | Every value is a non-empty string | Pass |
| UT-ROLEID-02 | | Ids are unique | Read every constant in `Roles` | No two constants share a value | Pass |
| UT-ROLEID-03 | | Ids use the `ROLE_` prefix | Read every constant in `Roles` | Every value starts with `ROLE_` | Pass |
| UT-ROLEID-04 | | Id format | Read every constant in `Roles` | Every value matches `^ROLE_[A-Z]+$` (upper case, no spaces) | Pass |

### 1.3 Night order data (`src/logic/rules/night_order.gd`): `test/unit/rules/test_night_order.gd`

Checks the lists are well formed. Waking roles is not built, so it isn't tested.

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-NIGHT-01 | §8 | First night has no duplicates | Read `NightOrder.FIRST_NIGHT` | Each role id appears once | Pass |
| UT-NIGHT-02 | §8 | Other nights have no duplicates | Read `NightOrder.OTHER_NIGHTS` | Each role id appears once | Pass |
| UT-NIGHT-03 | §8 | Every entry is a known role | Check each entry of both lists against the `Roles` constants | Every entry is a defined role id | Pass |
| UT-NIGHT-04 | §8 | Lists are not empty | Read both lists | Both have at least one entry | Pass |

### 1.4 RoleDef (`src/logic/model/role_def.gd`): `test/unit/model/test_role_def.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-ROLEDEF-01 | | Constructor stores fields | `RoleDef.new(&"ROLE_X", "X", MINION, ability)` | `id`, `display_name`, `team`, `ability` equal the arguments | Pass |
| UT-ROLEDEF-02 | | Null ability allowed | `RoleDef.new(..., null)` | Object is created, `ability` is `null` | Pass |
| UT-ROLEDEF-03 | | Each team can be stored | Build one role per `Kind` | `team` equals the kind passed in | Pass |

### 1.5 PlayerState (`src/logic/model/player_state.gd`): `test/unit/model/test_player_state.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-PLAYER-01 | | Constructor stores fields | `PlayerState.new(&"p1", "Ann", 3, role, shown)` | `id`, `username`, `seat_no`, `role`, `shown_role` equal the arguments | Pass |
| UT-PLAYER-02 | §2 | Defaults for a new player | Create a player | `alive` true, `has_last_vote` true, `departed` false, `statuses` empty | Pass |
| UT-PLAYER-03 | | Missing status is false | `has_status(&"hexed")` on a new player | `false` | Pass |
| UT-PLAYER-04 | | Set status is true | `statuses[&"hexed"] = true`, then `has_status(&"hexed")` | `true` | Pass |
| UT-PLAYER-05 | | Cleared status is false | `statuses[&"hexed"] = false`, then `has_status(&"hexed")` | `false` | Pass |
| UT-PLAYER-06 | | Statuses are independent | Set `hexed`, query `protected` | `protected` is `false` | Pass |
| UT-PLAYER-07 | RULE-40 | In play: alive, not departed | Default player | `is_in_play()` is `true` | Pass |
| UT-PLAYER-08 | RULE-40 | Not in play: dead | `alive = false` | `is_in_play()` is `false` | Pass |
| UT-PLAYER-09 | RULE-40 | Not in play: departed | `departed = true` | `is_in_play()` is `false` | Pass |
| UT-PLAYER-10 | RULE-40 | Not in play: dead and departed | `alive = false`, `departed = true` | `is_in_play()` is `false` | Pass |
| UT-PLAYER-11 | RULE-08 | Shown role can differ from role | Create with different `role` and `shown_role` | Both are kept as given | Pass |
| UT-PLAYER-12 | | Players don't share statuses | Two players; set a status on one | The other has no statuses | Pass |

### 1.6 GameState: defaults and lookup (`src/logic/model/game_state.gd`): `test/unit/model/test_game_state.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-STATE-01 | §4 | Defaults for a new game | `GameState.new()` | `phase` SETUP, `day_number` 0, `night_number` 0, `result` null, no players | Pass |
| UT-STATE-02 | | Find player by id | 5-player game; `find_player_by_id(&"p2")` | Returns the player in seat 2 | Pass |
| UT-STATE-03 | | Unknown id | `find_player_by_id(&"nobody")` | `null` | Pass |
| UT-STATE-04 | | Empty game | New state; `find_player_by_id(&"p0")` | `null` | Pass |
| UT-STATE-05 | | Duplicate ids | Two players with id `p0` | Returns the first one in the list | Pass |
| UT-STATE-06 | | Lookup finds dead players | Kill p2; look it up | Still returns p2 | Pass |

### 1.7 GameState: living neighbours: `test/unit/model/test_game_state_neighbours.gd`

Seats form a ring. A neighbour is the nearest **in-play** player on each side.

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-STATE-07 | §7 | Middle seat, all alive | 5 players; neighbours of seat 2 | Seats 1 and 3 | Pass |
| UT-STATE-08 | §7 | Wraps around the ring | 5 players; neighbours of seat 0 | Seats 4 and 1 | Pass |
| UT-STATE-09 | §7 | Last seat wraps to first | 5 players; neighbours of seat 4 | Seats 3 and 0 | Pass |
| UT-STATE-10 | | Uses seat order, not list order | Add players in shuffled order; neighbours of seat 2 | Seats 1 and 3 | Pass |
| UT-STATE-11 | §7 | Skips a dead player | Kill seat 3; neighbours of seat 2 | Seats 1 and 4 | Pass |
| UT-STATE-12 | RULE-40 | Skips a departed player | Seat 1 departed; neighbours of seat 2 | Seats 0 and 3 | Pass |
| UT-STATE-13 | §7 | Skips several in a row | 7 players; kill seats 3, 4, 5; neighbours of seat 2 | Seats 1 and 6 | Pass |
| UT-STATE-14 | | Two players in play | 5 players, only seats 0 and 2 alive; neighbours of seat 0 | Exactly one neighbour, seat 2, listed once | Pass |
| UT-STATE-15 | | Nobody else in play | Everyone except seat 0 dead | Empty list | Pass |
| UT-STATE-16 | | One-player game | 1 player | Empty list | Pass |
| UT-STATE-17 | | Target is dead | Kill seat 2; neighbours of seat 2 | Still seats 1 and 3 | Pass |
| UT-STATE-18 | | Does not reorder players | Shuffled players; call `living_neighbours` | `players` keeps its original order | Pass |
| UT-STATE-19 | | Never includes the target | Every seat of a 5-player game | The player is never in its own list | Pass |
| UT-STATE-20 | | At most two neighbours | Every seat of a 9-player game | List size is 2 | Pass |

### 1.8 Reveals (`src/logic/info/reveal/*`): `test/unit/info/test_reveals.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-REVEAL-01 | | Role reveal kind | `RoleReveal.new(&"ROLE_A").kind()` | `RevealKind.ROLE` | Pass |
| UT-REVEAL-02 | | Role reveal id | `RoleReveal.new(&"ROLE_A").id()` | `&"ROLE_A"` | Pass |
| UT-REVEAL-03 | | Role reveal matches same role | Player with role `ROLE_A` | `matches` is `true` | Pass |
| UT-REVEAL-04 | | Role reveal rejects other role | Player with role `ROLE_B` | `matches` is `false` | Pass |
| UT-REVEAL-05 | RULE-08 | Role reveal uses real role | Player: real `ROLE_A`, shown `ROLE_B` | `RoleReveal(ROLE_A)` matches, `RoleReveal(ROLE_B)` does not | Pass |
| UT-REVEAL-06 | | Team reveal kind | `TeamReveal.new(MINION).kind()` | `RevealKind.TEAM` | Pass |
| UT-REVEAL-07 | | Team reveal id | `TeamReveal.new(k).id()` for every kind | Equals `Teams.get_id(k)` | Pass |
| UT-REVEAL-08 | | Team reveal matches same team | Minion player; `TeamReveal(MINION)` | `true` | Pass |
| UT-REVEAL-09 | | Team reveal rejects other team | Townsfolk player; `TeamReveal(MINION)` | `false` | Pass |
| UT-REVEAL-10 | RULE-08 | Team reveal uses real team | Real Outsider, shown Townsfolk | `TeamReveal(OUTSIDER)` matches, `TeamReveal(TOWNSFOLK)` does not | Pass |
| UT-REVEAL-11 | | Reveals are a `Reveal` | Create one of each | Both are `Reveal` instances | Pass |

### 1.9 GameResult (`src/logic/info/result/game_result.gd`): `test/unit/info/test_game_result.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-RESULT-01 | | Good win stores winners | `GameResult.new(true, [p0, p1])` | `good_won` true, `winners` is `[p0, p1]` | Pass |
| UT-RESULT-02 | | Evil win stores winners | `GameResult.new(false, [p2])` | `good_won` false, `winners` is `[p2]` | Pass |
| UT-RESULT-03 | | Empty winners allowed | `GameResult.new(true, [])` | `winners` is empty | Pass |

### 1.10 PlayerView entry (`src/logic/model/player_view.gd`): `test/unit/model/test_player_view_entry.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-VIEW-01 | NET-07 | No reveal: empty id | `PlayerEntry` with no reveal; `reveal_id()` | `&""` | Pass |
| UT-VIEW-02 | NET-07 | No reveal: empty kind | `PlayerEntry` with no reveal; `reveal_kind()` | `&""` | Pass |
| UT-VIEW-03 | | Role reveal passes through | Entry with `RoleReveal(ROLE_A)` | `reveal_id` `ROLE_A`, `reveal_kind` `role` | Pass |
| UT-VIEW-04 | | Team reveal passes through | Entry with `TeamReveal(MINION)` | `reveal_id` `TEAM_MINION`, `reveal_kind` `team` | Pass |

### 1.11 Health (`src/logic/health.gd`): `test/unit/test_health.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-HEALTH-01 | | Starts at max | `Health.new(100)` | `current` is 100 | Pass |
| UT-HEALTH-02 | | Damage reduces health | `take_damage(30)` | `current` is 70 | Pass |
| UT-HEALTH-03 | | Floors at zero | `take_damage(999)` | `current` is 0 | Pass |
| UT-HEALTH-04 | | Heal capped at max | `take_damage(10)`, `heal(50)` | `current` is 100 | Pass |
| UT-HEALTH-05 | | Zero/negative ignored | `take_damage(n)`, `heal(n)` for n in -5, 0 | `current` stays 100 | Pass |
| UT-HEALTH-06 | | `died` emitted once | `take_damage(100)`, `take_damage(10)` | `died` emitted exactly once | Pass |
| UT-HEALTH-07 | | No healing when dead | `take_damage(100)`, `heal(50)` | Still dead | Pass |
| UT-HEALTH-08 | | `changed` carries values | `take_damage(30)` | `changed` emitted with `(70, 100)` | Pass |
| UT-HEALTH-09 | | Max is at least 1 | `Health.new(n)` for n in 0, -10 | `maximum` and `current` are 1 | Pass |
| UT-HEALTH-10 | | Ignored amounts emit nothing | `take_damage(0)`, `heal(-5)` | `changed` not emitted | Pass |
| UT-HEALTH-11 | | Alive at start | `Health.new(100)` | `is_dead()` false | Pass |

### 1.12 PlayerView: who sees what: `test/unit/model/test_player_view.gd`

Fixture game: seat 0 Demon, seats 1–2 Minions, seat 3 Outsider, seats 4–6 Townsfolk.

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-VIEW-05 | NET-07 | One entry per player | Build view for seat 4 | 7 entries; `observer_id` is `p4` | Pass |
| UT-VIEW-06 | | Public fields copied | Kill seat 5, depart seat 6; build view | Each entry has the right id, username, seat, alive, departed | Pass |
| UT-VIEW-07 | LOB-07 | Player sees own role | Build view for seat 4 | Own entry is `RoleReveal` of own role | Pass |
| UT-VIEW-08 | RULE-08 | Player sees shown role, not real role | Seat 3: real Outsider, shown a Townsfolk role; build view for seat 3 | Own entry shows the shown role id | Pass |
| UT-VIEW-09 | NET-07 | Townsfolk sees no one else | Build view for seat 4 | Every other entry has no reveal | Pass |
| UT-VIEW-10 | NET-07 | Outsider sees no one else | Build view for seat 3 | Every other entry has no reveal | Pass |
| UT-VIEW-11 | RULE-10 | Demon sees Minions as team only | Build view for seat 0 | Seats 1–2 are `TeamReveal(MINION)` | Pass |
| UT-VIEW-12 | RULE-10 | Minion sees the Demon's role | Build view for seat 1 | Seat 0 is `RoleReveal` of the Demon's role | Pass |
| UT-VIEW-13 | RULE-10 | Minion sees other Minion as team | Build view for seat 1 | Seat 2 is `TeamReveal(MINION)` | Pass |
| UT-VIEW-14 | NET-07 | Evil sees no good roles | Build views for seats 0 and 1 | Seats 3–6 have no reveal | Pass |
| UT-VIEW-15 | | Reveals are true | Build view for each evil player | Every reveal `matches` the player it is attached to | Pass |
| UT-VIEW-16 | RULE-10 | Dead evil still known | Kill seat 2; build view for seat 0 | Seat 2 still `TeamReveal(MINION)`, `is_alive` false | Pass |
| UT-VIEW-17 | | Building a view changes nothing | Build views for every player | Game state players unchanged (order, alive, departed, statuses) | Pass |
| UT-VIEW-18 | NET-07 | Views are separate | Build views for seats 0 and 4 | They don't share entry objects | Pass |

### 1.13 Seating over a game: `test/unit/model/test_seating.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-SEAT-01 | §7 | Neighbours update as players die | 7 players; kill seats 1, 6, 2, 5 one at a time; check seat 0 after each | Seat 0's neighbours move outward each step | Pass |
| UT-SEAT-02 | RULE-40 | Departed counts like dead | Same game twice: once killing seat 1, once departing it | Seat 0's neighbours are the same both times | Pass |
| UT-SEAT-03 | | Neighbours are mutual | 9 players with some dead; for every in-play pair | If A lists B, B lists A | Pass |
| UT-SEAT-04 | | Revived player is a neighbour again | Kill seat 1, then set `alive = true` | Seat 0's neighbours include seat 1 again | Pass |

### 1.14 Reveals over a game: `test/unit/info/test_reveals_in_game.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| UT-REVEAL-12 | | Team reveal counts | 7-player fixture game; for each kind count players `TeamReveal(kind)` matches | Counts are 3 Townsfolk, 1 Outsider, 2 Minion, 1 Demon | Pass |
| UT-REVEAL-13 | | Role reveal hits one player | For each player, test `RoleReveal(player.role.id)` on everyone | Matches exactly that player | Pass |
| UT-REVEAL-14 | | Exactly one Demon | Count `TeamReveal(DEMON)` matches | 1 | Pass |

---

## 2. Integration tests (`test/integration`)

Nodes and scenes in the scene tree.

### 2.1 Project loads: `test/integration/test_project_loads.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| IT-LOAD-01 | | All scripts load | Walk `res://src` and `res://constants`; `load()` every `.gd` | Every script loads (no parse errors) | Pass |
| IT-LOAD-02 | | All scenes instantiate | Walk `res://scenes`; load and instantiate every `.tscn` | Every scene loads and instantiates | Pass |

### 2.2 Health component: `test/integration/test_health_component.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| IT-HEALTH-01 | | Health built from export | Add component with `max_health = 10` | `health.maximum` is 10 | Pass |
| IT-HEALTH-02 | | Lethal damage emits `died` | `take_damage(10)` | `died` emitted | Pass |
| IT-HEALTH-03 | | Lethal damage frees owner | `take_damage(10)`, wait 2 frames | Parent node is freed | Pass |
| IT-HEALTH-04 | | Non-lethal damage keeps owner | `take_damage(5)`, wait 2 frames | Parent still valid, `died` not emitted | Pass |

---

## 3. End-to-end tests (`test/e2e`)

Boot the real main scene.

### 3.1 Main scene: `test/e2e/test_main_scene.gd`

| Test ID | Req | Title | Steps | Expected behaviour | Result |
| --- | --- | --- | --- | --- | --- |
| E2E-BOOT-01 | | Main scene is set | Read `application/run/main_scene` | Set, and the path loads as a `PackedScene` | Pass |
| E2E-BOOT-02 | | Main scene boots | Instantiate and add to tree | Node exists and is inside the tree | Pass |
| E2E-BOOT-03 | | Survives a second | Wait 1 s | Main node still valid | Pass |
| E2E-BOOT-04 | | Boots without errors | Boot and wait 1 s | No engine or `push_error` errors | Pass |
| E2E-BOOT-05 | | Clean teardown | Free the main scene, wait 2 frames | Node is freed, no errors | Pass |

---

## 4. Run log

**Run 1: 2026-11-20**, branch `test/roles` @ `d4907cf`, Godot 4.6.3 headless, GUT 9.6.1.

| Layer | Scripts | Tests | Passing | Failing | Asserts |
| --- | ---: | ---: | ---: | ---: | ---: |
| Unit | 11 | 77 | 77 | 0 | 234 |
| Integration | 5 | 27 | 27 | 0 | 196 |
| E2E | 1 | 5 | 5 | 0 | 9 |
| **Total** | **17** | **109** | **109** | **0** | **439** |

**Run 2: 2026-11-20**, branch `feat/roles` @ `2a51b4f` + layer/naming changes. Three
pure-logic files moved from integration to unit (IDs renumbered to UT-VIEW-05..18,
UT-SEAT-01..04 and UT-REVEAL-12..14), and requirement IDs were added to test names.

| Layer | Scripts | Tests | Passing | Failing | Asserts |
| --- | ---: | ---: | ---: | ---: | ---: |
| Unit | 14 | 98 | 98 | 0 | 404 |
| Integration | 2 | 6 | 6 | 0 | 26 |
| E2E | 1 | 5 | 5 | 0 | 9 |
| **Total** | **17** | **109** | **109** | **0** | **439** |

Each test case maps to one test function (109 cases, 109 tests). GUT counts a parameterised
test once. `gdlint src test` and `gdformat --check src test` both pass.

**Mutation check:** `PlayerView.build` was temporarily changed to reveal every player's real
role to everyone. UT-VIEW-09, UT-VIEW-10 and UT-VIEW-14 failed as they should, then the
change was reverted.

## 5. Defects and observations

No defects found in implemented code on this run.

| # | Area | Observation | Suggested action |
| --- | --- | --- | --- |
| O-1 | `GameState.living_neighbours` | Passing a player who isn't in `players` doesn't return empty or error: `find` gives -1 and the loop returns arbitrary players. No test, because no expected behaviour is defined. | Decide: return `[]` or `assert`. Then add UT-STATE-21. |
| O-2 | `PlayerView.build` | Minions see the Demon's **shown** role, not the real one. That's the same today, because no Demon has a different shown role. If one ever does (e.g. a disguise), UT-VIEW-15 will flag it. | Confirm which one minions should see. |
| O-3 | Roles | `constants/players/roles.gd` and `night_order.gd` use different role names from `rules.md` (Village/Strays/Cultists/Fiend). Role tests are role-agnostic until that's settled. | Align the constants with `rules.md`. |

### Not covered yet (stubs or not built)

No test files until these are built: `GameState.living_players` (returns `[]`), `Ability` hooks,
`NightOrder` waking, `Effect` / `GameEvent` / `Query` (abstract or empty), and everything in
`rules.md` §3–6 and `requirements.md` (setup, voting, win checks, lobby, networking, movement,
voice).
