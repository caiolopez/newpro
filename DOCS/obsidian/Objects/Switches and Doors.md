### Doors
- Doors are rectangular platforms of variable shape that will act according to their triggering events;
- Doors can "open" in any direction (upwards, to the left, diagonally, etc);
- Doors move to their final position by performing an "easeOutQuart" acceleration curve;

Doors can be of the following type:

- Free Door
  - Will open when touched by hero;
  - Will close itself after a tunable amount of time set for each instance of door;
  - Will not close if hero, enemy or any other collidable object is on its path. If scheduled to close, will do it instantly after given clearance;
  - If half-way closing and collidable object gets on path, door will fully open again. If scheduled to close, will do it instantly after given clearance;

- Locked Door
  - Every locked door is assigned to a respective switch family;
  - A locked door will open as soon as its assigned switch family is set to active;
  - A locked door **can** be set to AUTOSHUT after a given amount of time after it was opened. In that case:
  - Will not close if hero, enemy or any other collidable object is on its path. If scheduled to close, will do it instantly after given clearance; 
  - Will reset its switch family to inactive instantly, as soon as this door timer is due.

### Switches
- Switches are objects that will change their status from inactive to active when overlapped by [[pellets]] (any pellet, including enemies');
- Switches can be set to move constantly;
- Switches can be grouped in families. All family members must be active in order for that family to act upon assigned doors;
- Activation of families can be:
  - Normal: Family members can be activated in any order;
  - Simultaneously: Family members must be activated roughly all at the same time. I.e., all switches must be overlapped by pellets at a very strict time window of a few milliseconds. Each switch monitors its own time window. Should all switches be on at the same time, the door opens;
  - Sequential: Family members must be activated in a very specific order. Any switch activated in the wrong order will reset all family switches instantly;
- Dying will cause all partially-active families to reset their switches to inactive, i.e., when hero dies, active switches that are part of a family that bears inactive switches are set to inactive instantly.