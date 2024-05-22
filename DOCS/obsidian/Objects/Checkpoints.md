- Each Checkpoint comprises a CHECKPOINT TRIGGER and a SPAWN ANCHOR;
- Whenever the hero overlaps a CHECKPOINT TRIGGER, that Checkpoint becomes the active Checkpoint;
- You can only have one active Checkpoint in the game at any given time;
- A Checkpoint cannot be triggered if it's already Active -- i.e, only inactive Checkpoints can be activated;
- In order to deactivate a Checkpoint, hero must overlap another Checkpoint's CHECKPOINT TRIGGER;
- Dying will make the hero respawn where the active Checkpoint's SPAWN ANCHOR is;
- Activating a Checkpoint COMMITS changes to other objects, such as open doors, lit switches, broken blocks, killed enemies and so on;
- Dying FLUSHES all uncommitted changes to objects, reseting gameplay to last COMMITTED state;
- There are a few exceptions to the COMMIT and FLUSH mechanic, such as COLLECTIBLES, which are instantaneously saved as collected regardless of COMMITTING -- Dying will never cause the player to lose a collected COLLECTIBLE;
- Changes to particles and other cosmetic objects that don't impact gameplay are mostly never COMMITTED.

Respawn facing-direction

- FACING DIRECTION is an attribute that forces player to be facing a specific direction upon respawning there. Values can be:

 - LEFT - Player will respawn facing left
 - RIGHT - Player will respawn facing right
 - AS_RECORDED - Player will respawn facing the direction he/she was when checkpoint was activated

#trigger