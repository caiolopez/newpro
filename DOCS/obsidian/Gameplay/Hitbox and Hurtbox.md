- hero, enemies, interactive and destructible objects all have both a hitbox (used for collision detection with level and each other) and a hurtbox (used for interaction tests);
- Hurtboxes size and position should be set differently for different animation states. E.g, hero can be harder to hit when curled into a ball.

Not all objects interaction have collision:
 - Enemies will not collide with each other;
 - Enemies will not collide with hero (although touching them kills hero);
 - Collectibles will not collide with hero.