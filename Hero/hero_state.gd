class_name HeroState extends _State

var hero:CharacterBody2D

# The type of the state the HERO uses

func enter(new_machine:StateMachine) -> void:
 hero = new_machine.owner as CharacterBody2D
 super(new_machine)
