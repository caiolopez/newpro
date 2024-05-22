*kills hero when OoB to avoid softlocks and abuse*

Regardless of how well implemented a game is, players will always find ways to break it in completely unexpected ways. One of the ways is walking OUT OF BOUNDS (OOB). We must be prepared!

- The game must be able to respawn hero shortly after (not necessarily instantaneously) hero enters OoB position -- we can think of it as a sort of kill trigger;
- This process must be computationally cheap;
- Although not ideal due to error-proneness, If needed, invisible oob-kill triggers can be manually inserted throughout the level's OoB regions. Bear in mind that overlaps between hero's hurtbox and oob-kill triggers don't need to be checked every frame, so as to make calculations more easy on the processor;
- Due to its unintended, accidental nature, oob-related deaths will not increase the death counter.

#trigger 