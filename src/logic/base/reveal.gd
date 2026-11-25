@abstract
## An abstract class, representing something that a player can
## learn about another player. This may be in a form of its
## team or role.
class_name Reveal
extends RefCounted


## Stable list of ids for all type of reveals in the game
class RevealKind:
	const ROLE := &"REVEAL_ROLE"
	const TEAM := &"REVEAL_TEAM"
	const ALIGNMENT := &"REVEAL_ALIGNMENT"


@abstract
## Returns which kind of reveal this is: one of the [RevealKind] constants.
func kind() -> StringName

@abstract
## Returns the stable id of what is being revealed.
func id() -> StringName

@abstract
## Checks the player's real role. Returns [code]true[/code] if
## [param player] fits the reveal, otherwise returns
## [code]false[/code].
func matches(player: PlayerState) -> bool
