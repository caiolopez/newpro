#### Hero can:
- **Glide** by holding jump during fall;
- **Jump** different heights according to the button press time. Releasing the jump button causes hero vertical speed to LERP to zero. LERP factor is also tunable;
- Hero can only jump when collided with WALL or FLOOR, or during coyote-time;
-  Coyote-time is a small time window after hero falls off a ledge in which hero can still perform jump even if not grounded anymore;
- **Walljump** by jumping while [[Glossary#^bc0ef7|wallhugging]] airborne;
- **Wallgrab** by holding jump while [[Glossary#^bc0ef7|wallhugging]] airborne;
- **Dummyjump**: Performing a [[Shooting|powershot]] while airborne will grant hero the ability to perform ONE extra jump while not collided with floor. This second, airborne jump is a dummyjump. After performing a dummyjump, hero states becomes dummyfall, which makes hero unable to GLIDE, SHOOT or POWERSHOOT unless hero touches FLOOR or WALL. Dummyjump height and other parameters are different than those of regular jump; ^a3fbd4
- **Waterbounce**: See [[Water Environment#^3e04a2|Water Environment: Waterbounce]]

#### Walljump input buffer
- In order to avoid frustrated walljump attempts -- those in which the player pushes JUMP a few frames before actually having hero touching the wall and ends up not walljumping at all -- Tigermoth will implement a short walljump input buffer;
- WHILE AIRBORNE, hitting a wall WHILE HOLDING JUMP a few frames (about 3 to 6 frames) AFTER the JUMP button was pressed will cause hero to walljump;
- Players won't really know that we're cheating for them, so they will just find the game to be less frustrating and more comfortable overall.

#### Ground jump input buffer
- Similar to the walljump input buffer, but relative to ground jumps;
- A jump input that happens too soon (a few frames before hero actually touches ground) will still work, provided that jump button is still held down upon collision with ground;
- Tunable amount of frames.

#### Off-Wall Walljump
- In order to allow hero to walljump in the OPPOSITE direction of the wall:
  - If hero IS NOT on floor AND
  - hero was collided with wall less than [N] frames ago AND
  - hero is pushing the OPPOSITE DIRECTION from the wall he/she is/was collided with AND
  - Player pushes JUMP Button.
- hero walljumps. YAY!!

#### Wallgrab Hangtime
- The Wallgrab hangtime is the few milliseconds after exiting the wallgrab state to the falling state in which hero's vertical speed is fixed to zero. This feature aims to make walljumping less punitive for players that are too slow to push the jump button;
- I.e., leaving the wallgrab state to the falling state will grant hero a very small timeframe in which the hero will not accelerate downwards, as long as player is still pushing against the wall with the directionals.

#### Keyboard directional consideration
- Contrary to analogs and d-pads, the keyboard allows players to hold two opposing directions at the same time. In the case where both left and right (A and D) are pressed at the same time, the last inserted input will be the active. Releasing it will fall back to the other direction currently pressed.