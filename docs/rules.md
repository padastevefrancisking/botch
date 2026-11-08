# Botch: Game Rules

Status: **Draft v0.1**. This is the source of truth for game rules. Change it through a PR,
and give every new rule an ID so issues and tests can reference it (e.g. `RULE-12`).

System requirements (networking, storyteller tools, movement, voice) live in
[requirements.md](requirements.md).

---

## 1. Overview

Botch is a social-deduction game for **5–15 players** plus one **Storyteller**.
Each player secretly belongs to a team:

| Team | Side | Summary |
| --- | --- | --- |
| **Village** | Good | Ordinary townspeople with helpful abilities. |
| **Strays** | Good | Good players whose abilities cause trouble for their own side. |
| **Cultists** | Evil | Helpers of the Fiend. They know who the Fiend is. |
| **Fiend** | Evil | Kills one player each night. There is exactly one. |

Good wins by killing the Fiend. Evil wins by whittling the living players down.

---

## 2. Glossary

| Term | Meaning |
| --- | --- |
| Player | Someone seated in the game with a role. The Storyteller is not a player. |
| Role | A character with a name, a team and an ability. |
| Alignment | Good or evil. |
| Living / dead | Dead players stay in the game, can talk, and keep one **last vote**. |
| Departed | A player who disconnected mid-game (see `RULE-40`). |
| Register as | What an information ability "sees". Usually a player's real role and alignment, but some abilities change it. |
| Hexed | Under the Hexer's effect: their ability fails and any information they get may be false. |
| Bag | The set of role tokens the Storyteller prepares for a game. |
| Ledger | The Storyteller's private view of every role, status and night action. |

---

## 3. Setup

| ID | Rule |
| --- | --- |
| RULE-01 | A game needs **at least 5 and at most 15 players**. The Storyteller does not count. The game cannot start outside this range. |
| RULE-02 | The Storyteller prepares a **bag** with exactly one token per player, matching the distribution table (`RULE-03`). |
| RULE-03 | Team counts by player count (draft, to be tuned through playtests): see the table below. |
| RULE-04 | **No role appears twice** in a game. A bag with a duplicate role cannot be confirmed. |
| RULE-05 | Each player **picks one face-down token** from the bag. Two players cannot pick the same token. When all tokens are taken, each player privately sees their own role. |
| RULE-06 | The Fiend always has exactly 1 token in the bag. |
| RULE-07 | **Setup modifiers.** Some roles change the team counts while they are in the bag (currently only the Patron: −1 Village, +1 Stray). The bag is checked against the table *after* modifiers are applied. |
| RULE-08 | **Shown role.** The Sleepwalker's token is a Stray, but its player is shown a different role: a Village role that is not in the bag and whose ability chooses players (Lamplighter, Scales, Warden, Tracker, Mender or Duelist). The Storyteller picks it. Information abilities still see the real role (Sleepwalker, a Stray). |

### Distribution table (`RULE-03`)

| Players | Village | Strays | Cultists | Fiend |
| ---: | ---: | ---: | ---: | ---: |
| 5 | 3 | 0 | 1 | 1 |
| 6 | 4 | 0 | 1 | 1 |
| 7 | 4 | 1 | 1 | 1 |
| 8 | 5 | 1 | 1 | 1 |
| 9 | 5 | 1 | 2 | 1 |
| 10 | 6 | 1 | 2 | 1 |
| 11 | 6 | 2 | 2 | 1 |
| 12 | 7 | 2 | 2 | 1 |
| 13 | 7 | 2 | 3 | 1 |
| 14 | 8 | 2 | 3 | 1 |
| 15 | 9 | 2 | 3 | 1 |

Each row must add up to the player count. The role list in section 7 has enough roles
of each team to fill the largest row, including the Patron's extra Stray: 13 Village (up to 9 needed),
4 Strays (up to 3), 5 Cultists (up to 3), 1 Fiend.

---

## 4. Game flow

```
Lobby → Setup → First Night → Day → Night → Day → … → Game Over
```

| ID | Rule |
| --- | --- |
| RULE-10 | **First Night.** Evil players learn each other: every Cultist learns who the Fiend is, and the Fiend learns who the Cultists are. The Fiend also learns **3 Village roles that are not in play**, to use as cover stories. First-night abilities then resolve in night order (section 8). The Fiend does not kill on the first night. |
| RULE-11 | **Day.** Players move around, talk and make nominations (section 5). At most **one execution** happens per day. |
| RULE-12 | **Night.** Players cannot move or speak to each other. The Storyteller wakes roles one at a time in night order. Deaths caused at night are announced at dawn. |
| RULE-13 | Every phase has a **timer**, but the timer never advances the phase by itself. When it runs out, everyone is told time is up, and the **Storyteller advances the phase** when ready. The Storyteller may also advance at any time before the timer ends. |
| RULE-14 | Win conditions (section 6) are checked after every death, every execution, every disconnect and every phase change. The game ends as soon as one is met. |

---

## 5. Nominations, voting and execution

| ID | Rule |
| --- | --- |
| RULE-20 | During the day, after the Storyteller opens nominations, any **living** player may nominate any player (living or dead), including themselves. |
| RULE-21 | Each player may **make** at most one nomination per day, and each player may **receive** at most one nomination per day. |
| RULE-22 | After a nomination, players vote. Living players may vote on every nomination. |
| RULE-23 | Each dead player has **one last vote** for the rest of the game. Using it on any nomination spends it. |
| RULE-24 | A nomination is **on the block** if its votes are at least **half the living players, rounded up**, *and* strictly more than any earlier nomination that day. |
| RULE-25 | If a later nomination **ties** the one on the block, nobody is on the block. |
| RULE-26 | When the Storyteller closes the day, the player on the block (if any) is **executed** and dies. Then the game moves to night. |
| RULE-27 | Votes and their counts are public. |

---

## 6. Winning

| ID | Rule |
| --- | --- |
| RULE-30 | **Good wins** when the Fiend dies (or departs, see `RULE-40`). |
| RULE-31 | **Evil wins** when only **2 living players** remain and one of them is the Fiend. |
| RULE-32 | If both a good and an evil win condition are met by the same event, **good wins**. |
| RULE-40 | **Disconnects.** A player who disconnects mid-game becomes **Departed**: they count as dead for win checks and their role is not revealed. Win conditions are re-checked immediately. If they reconnect, they join as a spectator and do not take their seat back. |
| RULE-41 | The Storyteller may also **end the game manually** and declare a winner (e.g. too many players left). |

---

## 7. Roles

Abilities happen only while the player is alive, unless the ability says otherwise.
"Each night" means every night including the first; "each night\*" means every night
**except the first**.

### Village (good)

| Role | Ability |
| --- | --- |
| **Lamplighter** | Each night, choose a player. You learn how many evil players are among them and their two living neighbours (0–3). |
| **Archivist** | First night only, you learn how many Strays are in play. |
| **Scales** | Each night, choose two players. You learn whether they are on the **same team** (good/good or evil/evil) or not. |
| **Gravedigger** | Each night\*, you learn the alignment of the player executed today, if any. |
| **Warden** | Each night\*, choose another player. If the Fiend attacks them tonight, they survive. You cannot choose the same player two nights in a row. At dawn you learn whether your protection was used. |
| **Bell-ringer** | Once per game, during the day, ring the bell. The Storyteller publicly announces how many evil players are alive. |
| **Tracker** | Each night\*, choose a player. You learn whether they woke to use an ability tonight. |
| **Judge** | Once per game, during the day, after the Storyteller closes the day, you may **cancel** today's execution. Everyone learns the Judge did it. |
| **Sentinel** | The first time the Fiend attacks you, you survive. At dawn, everyone learns that "an attack failed" (not who). |
| **Oracle** | When you die (by any means), the Storyteller tells you the role of **one evil player** of their choice. |
| **Mender** | Once per game, at night\*, choose a dead player. They return to life at dawn with their ability. Departed players cannot be chosen. |
| **Elder** | While you are alive, your vote counts as **two votes**. |
| **Duelist** | Once per game, during the day, publicly challenge a player. If exactly one of you is evil, the evil one dies. Otherwise nothing happens. |

### Strays (good)

| Role | Ability |
| --- | --- |
| **Martyr** | If you are executed, the player who nominated you **dies tonight**. |
| **Lookalike** | You may **register as evil** (as a Cultist or the Fiend) to information abilities, at the Storyteller's choice. |
| **Debtor** | You cannot vote unless another living player **lends** you their vote for that nomination. They cannot vote on it themselves. |
| **Sleepwalker** | You do not know you are the Sleepwalker. You are shown a **Village role that chooses players** and is not in play (`RULE-08`), and you act as it. Your ability works, but **every player you choose is swapped for one of their living neighbours** (Storyteller's pick). Information you get is true, but about the swapped player. When you die, you learn you were the Sleepwalker. |

### Cultists (evil)

| Role | Ability |
| --- | --- |
| **Hexer** | Each night, choose a player. They are **hexed** tonight and tomorrow: their ability fails and any information they get may be false. You cannot choose the same player two nights in a row. |
| **Mimic** | You **register as a Village role** of your choice to information abilities. Each night\*, you may change which one. |
| **Eavesdropper** | You can hear voices **through building walls**, in both directions (inside to outside and outside to inside), at normal range. Others cannot hear you through walls. |
| **Saboteur** | Once per game, during voting, you may secretly add or remove **one vote** from a nomination's total. The Storyteller applies it. |
| **Patron** | *Setup:* while the Patron is in the bag, **one Village token is replaced with a Stray** (`RULE-07`). No night action. |

### Fiend (evil)

| Role | Ability |
| --- | --- |
| **Fiend** | Each night\*, choose a player: they die. If no one dies to your attack in a night (protected, Sentinel, or you chose nobody), the **next night you choose two** players. |

---

## 8. Night order

Roles wake in this order. Roles not in play, dead (unless the ability works when dead), or with a
spent ability are skipped. The Sleepwalker wakes at the position of their **shown** role.

**First night:** evil players learn each other → Fiend learns 3 not-in-play roles → Hexer → Mimic → Archivist → Lamplighter → Scales

**Other nights:** Hexer → Mimic → Warden → Fiend → Mender → Gravedigger → Lamplighter → Scales → Tracker → Oracle (if they died tonight)

---

## 9. Storyteller discretion

| ID | Rule |
| --- | --- |
| RULE-50 | Whenever an ability says information "may be false" or a role "may register as" something, the Storyteller chooses. |
| RULE-51 | The Storyteller should keep the game fair and close. Ledger notes are private and never shown to players. |
| RULE-52 | The Storyteller resolves any rules question not covered here, and the answer is added to this document afterwards. |

---

## 10. Open questions

- **Role picking:** this draft has players pick a face-down token (`RULE-05`) so roles stay secret. If you meant players choose a role they can see, that breaks hidden information, so it needs a different rule.
- **Distribution table:** the numbers are a starting point. Adjust them after playtests.
- **Departed + Mender:** this draft says Departed players cannot be brought back. Confirm.
- **Parity win:** should evil also win when living evil players equal or outnumber living good players? This draft leaves it out, because with 5 players it would end the game after the first wrong execution.
- **Storyteller as player:** can the host be both a player and the Storyteller? This draft says no.
