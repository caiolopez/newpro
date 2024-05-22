### General ###
- There are 20 collectibles;
- Collecting a collectible will increase the collectible count by one;
- Collectibles are scientists NPCs locked in rooms called cells;
- The game forces collectible encounter order to be always the same -- i.e, the first scientist will be STEVE no matter where you find him in the game;

![[collectibles.png]]

- A button (1) opens a cell door (2) and changes the state of the scientist (3) to FREE.
- Overlapping the scientist dialog trigger (4) will cause dialog to take place. Controls are not halted. Player can advance a multi-paged dialog by pushing "down".
- Exiting and re-entering scientist dialog trigger (4) will cause multi-paged dialog to start from page one. 
- FREE scientists are despawned when off-camera, and a "thank you" letter (5) is placed where the scientist used to be within the cell.
- Each scientist has a name, an avatar, his/her dialog pages and a "thank you" letter. Each "thank you" letter also has a multi-paged dialog.
- "Thank you" letters are never despawned.

### Scientists are always shown in the same order ###

Scientists are show in order, so the player will always encounter the same scientists in the same order, regardless of where within the level he/she found them. The game only "figures out" which scientist to show when hero shoots the door switch button, which opens the cell and sets the scientist free.
- Upon shooting the switch button ON, the game will allocate the respective scientist and his/her respective room decoration assets.