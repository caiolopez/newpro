- Standard Block: behaves like a wall or floor, but can be set to move both vertically and horizontally -- but never rotate;
- Ice Block: similar to standard block, but destructible when shot with the [[Incendiary Ammo|incendiary ammo powerup]]. A collision between an ice block and an incendiary shot will NOT cause the incendiary shot to be destroyed; ^08e910
- Reflexive Block: will cause shots to ricochete at an angle (tunable);
- Ice Spike: similar to Ice Block, but deals damage to enemies and hero when overlapped;
 - Spikes adjacent to a recently destroyed ice-block should be also destroyed, provided that the spikes are facing away from the wall:
![[ice_spikes.png]]
- Destructible block: Similar to Standard Block, but can be destroyed with any shot (from either the hero or enemies). The shot that destroyed this block is also destroyed.
- Respawning Destructible Block: Will automatically respawn over a tunable amount of time after destroyed. Will not respawn if overlapped by other object, such as enemies and hero. In that case, will schedule its respawn to whenever the tile is clear.

Moving blocks implement [[Object Activation Options]].