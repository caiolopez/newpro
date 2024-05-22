#### Effects on hero
Overlapping a water object causes the physics of the hero to change. There are two different ways this interaction can be made:

- Not using the [[Aqualung]] Powerup
  - This causes the hero to float on water, being unable to dive. This will be referred to as the FLOATING state;
  - In FLOATING state, a constant upward acceleration causes hero to float;
  - Jumping in FLOATING state is not possible. In order to leave the body of water, hero must find a place to walljump.
![[water_flotation.gif]]

- Using the Aqualung Powerup
  - In this case, the hero sinks normally;
  - Gravity, walk speed, wall-glide and all the other movement values are of different values;
  - hero won't jump, walljump or dummyjump anymore; instead, holding the jump button will cause hero to ascend constantly, as if swimming upwards (with maximum up-swim speed and up-swim acceleration values);

#### Waterbounce
- When touching water WHILE in dummyfall state, hero can bounce off water by pushing jump instantly. This will cause the somersault to continue. The produced jump will be a dummyjump; ^3e04a2

#### Effects on Pellets (shot by hero)
- All hero shot pellets currently underwater are rapidly decelerated, and subjected to a downward acceleration (that is not the same as the hero's). This behavior is changed by the [[Underwater Ammo]] powerup.

#### Effects on Enemies
- None. There is no distinction between water and land.