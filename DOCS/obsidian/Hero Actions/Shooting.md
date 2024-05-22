- hero can shoot in 3 directions with XBOX X, Y and B. Respectively, shots will be fired FORWARD, UPWARD and BACKWARD;
- An [[Input Sequence Parser|input sequence event]] causes hero to shoot a POWERSHOT, which produces 3 to 5 pellets in a cone-shaped pattern;
POWERSHOTS can be shot FORWARD, UPWARD and BACKWARD, like simple shots do;  ^9cb1d5
- Pellets are instantly despawned when they leave the screen;
- There's a cap on the amount of pellets shot by hero that can exist simultaneously on screen. hero cannot spawn new pellets if the cap is met. The only exception is POWERSHOTS. POWERSHOTS pellets are always spawned, regardless of the amount of pellets already on screen. The cap is raised when hero is aboard a [[Pod]];
- hero can shoot and POWERSHOOT while airborne -- causing player to [[Movement#^a3fbd4|dummyjump]];

Powershot cooldown
- For [X]ms after a powershot was successfully shot, hero can't perform another powershot -- i.e, game will understand the powershot attempt, but nothing will come out of the gun;
- Let's Keep track of the failed powershot attempts, as we can implement a fail-to-shoot animation if needed.

Recoil

- Shooting may result in pushbacks: a brief period during which the hero is propelled horizontally backwards due simulated weapon recoil. Differences in jumping and falling speed can also occur. Implementation is very similar to WALLJUMPING state, having basically the same parameters;
- Regular shots and power shots have different recoil values.