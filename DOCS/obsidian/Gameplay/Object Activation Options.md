Objects that move around and change states, like enemies, moving blocks and hazards, are "paused" when they are not being shown.

### Activation Method
There are two alternative ways to activate a deactivated object: 
- Upon hero entering the object's **Activation Distance Radius**, or;
- Upon the camera getting the object **On Screen**;

### Deactivation Method

Conversely, the object can be deactivated by either leaving the screen, or leaving the distance radius, depending on the setup.

### Deactivation State
Defines what happens to a deactivated object.
It can be set to either:
- **Reset on deactivation**:  a recently deactivated object should be placed in its original place/state/moving cycle as soon as it deactivates;
- **Freeze  on deactivation**: a deactivated object should stay the same place/state/moving cycle it was left at.