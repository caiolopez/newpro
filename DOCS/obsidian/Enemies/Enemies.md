### Enemy Attributes

**MOVEMENT BEHAVIORS**:

- CHASER: Moves straight towards hero; Not affected by gravity;
 - COLLIDES WITH WALLS (OPTIONAL): May or may not collides with objects (option); Is dumb, so if path to hero is obstructed, behavior remains the same, and enemy will just struggle against the wall;
 - ATTEMPTS TO DODGE BULLETS (OPTIONAL): This causes the enemy to move away from incoming bullets;
 - Always collide with NO-CHASER triggers. NO-CHASER triggers make invisible walls that prevent CHASERS from leaving specific areas;
- CURVE_BASED (PATROL): Similar implementation to [[Blocks|moving blocks]] and [[Moving Hazard|moving hazards]];
 - Move on a predetermined way as set by the curve editor;
- WALKER (NECROSPHERE ZOMBIE): Like Necrosphere Zombies; Walks on the floor. Collides with walls, floors and ceilings; Once active, will attempt to align its horizontal position to hero's;
 - JUMPS (OPTIONAL): Jumps when facing walls; Jumps when hero passes over enemy (at a certain height threshold), attempting to grab hero mid-air; Jumps over incoming horizontal shots;
- ENVIRONMENT TRACKING (KOOPA TROOPA): Move automatically forward as long as its path is clear; turns back and moves backwards when reaches end of path, or upon collision with another collidable game object (if set to); Similar to Mario World's green-shelled koopa; May be WALLS ONLY, FLOOR/CEILING ONLY, or WALLS/FLOOR/CEILING; Will always change direction upon overlapping a NO-KOOPA trigger -- an invisible control object that prevents movement of this kind of enemy;
- NONE (still).

**COMBAT VARIABLES**

- HIT POINTS: The amount of hits an enemy takes before dying;
 - A value of ZERO will cause the enemy to be invincible. No damage animation should occur.
- EXPLODES WHEN OVERLAPPED BY PELLET (OPTIONAL);
 - EXPLOSION RADIUS.
- EXPLODES NEAR hero (OPTIONAL);
 - DISTANCE OF ACTIVATION;
 - EXPLOSION RADIUS;
- speed, inertia, gravity, jump height and pretty much everything else physics and movement related;
- SHOOTS PELLETS (OPTIONAL);
 - SPREAD CONE ANGLE: The wideness of the pellets directions;
 - ANGLE: The cone's center angle relative to enemy's direction. Forward is 0°; Can be set to point to hero's direction;
 - AMOUNT OF PELLETS PER SHOT: The amount of pellets that are simultaneously spawned every time the enemy shoots. Pellets must be evenly distributed throughout the spread cone angle;
 - AMOUNT OF MULTIPLE SHOTS: How many times the enemy will shoot while in shooting state;
 - DELAY BETWEEN MULTIPLE SHOTS: When an enemy shoots more than once per shooting state, the time distance between these shots;
 - FREQUENCY: How many seconds between shooting state and idle state;
 - PELLET SPEED: How fast enemy's pellets move. Pellets shot underwater by enemies are always unaffected (work the same way as dry shots).
 - DESTROYS PELLET: If the pellet that hits the enemy is destroyed upon collision.
 - REGENERATES: enemies with this traits can enter a RESTING state during which they stop and their HP is totally reset (max). Like a phoenix down.
	
### Extra Requirements
- It must be easily possible to script enemy behaviors such as:
 - Waiting still before shooting;
 - Waiting still after shooting;
 - Waiting still after time active;
 - Waiting still after getting hit (if still alive);
 - Spawning other enemies after shooting;
 - Spawning other enemies after dying;
 - Despawning itself upon time, shooting, OR being shot.

This object implements [[Object Activation Options]].
GD: List of enemy types [here](https://docs.google.com/spreadsheets/d/1mkV0OvmcTQXGlmY9xNqBQ6kAmmCMvm25eh5CC5zbOVg/edit#gid=0).

---

Chaser Anti-overlapping Algorithm

When two chaser enemies go after hero, it is common that they will overlap entirely and "become one". That sucks. A good measure to avoid this effect is to select any of two overlapping enemies and giving it a reasonably smaller LERP RATIO.

For instance, the red squares in the GIF file below:  
![[enemy_chaser_overlap.gif]]

---

Enemies must blink white when hit.