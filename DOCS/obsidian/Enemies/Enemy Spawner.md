*Invisible object that spawns enemies*

Variables:
- Enemy Type: The enemy that is supposed to be spawned;
- Spawning Interval: The amount of time between each enemy is spawned;
- Max amount of live sons (default: 5): Number of enemies created by this spawner that are still alive. After this value is reached, no more new enemies can be spawned again until some of them are destroyed to make room for the new ones;
- Trigger method: distance radius OR On Screen (default); This variable lets the designer choose which event should cause enemies to be created by a given spawner. Distance radius creates enemies when hero is within a certain distance from enemy spawner, whereas "on screen" simply checks if any part of the spawner is showing on screen;
- Enemies created via enemy spawner leave "volatile" [[Corpse|corpses]].
