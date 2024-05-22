---

#### **The default camera behaviors in Tigermoth are:**

- LERP-SMOOTHING follow camera (tunable ratio);
- FORBIDDEN ZONES for edge snapping.

#### **Additional, trigger-defined behaviors:**

- CAMERALOCK TRIGGER;
- LOOK-AHEAD TRIGGER;
- CUTSCENE TRIGGER.

---

#### **LERP-SMOOTHING**

- Every frame camera moves to a fraction of the distance between current camera position and camera target -- normally hero.

#### **FORBIDDEN ZONES**

- Invisible trigger objects that behave like "screen colliders", preventing the camera from moving through them;
- If hero is out of the threshold area, camera is allowed to ignore FORBIDDEN ZONES until there are no more FORBIDDEN ZONES on screen.

Example 1
![[camera_forbidden_zone_1.png]]
_The image above shows blue triggers called "FORBIDDEN ZONES"; an orange screen and a black hero circle. This illustrates what happens to camera when hero falls down and then goes back up._

Example 2
![[camera_forbidden_zone_2.png]]
_The image shows what happens to camera when hero falls down, walks a bit to the right and falls some more._





#### **CAMERALOCK TRIGGER**

- For as long as hero is overlapping the CAMERALOCK trigger, camera will be locked in either its VERTICAL or its HORIZONTAL axis. The axis that is not locked behaves naturally.
- When an axis is locked, the camera stays at the position the CAMERALOCK trigger ANCHOR POINT is. The anchor point is a child object to the CAMERALOCK trigger that marks where a locked axis is supposed to be locked at;
- It is possible to lock both VERTICAL and HORIZONTAL axis at the same time, by having two independent, overlapping triggers. E.g, let's say player is inside both a vertical lock and a horizontal lock. Leaving the vertical lock (but not the horizontal lock) should still leave the camera locked on the horizontal axis;

#### **LOOK-AHEAD TRIGGER**

- Adds a fixed offset to Camera Target. Useful for one-way corridors or large falls;

#### **CUTSCENE TRIGGER**

- Similar to CAMERALOCK, but will always lock both axis, and is only triggered once per overlap;
- Upon overlapping this trigger, player input is halted (except for pausing) and letterbox bars (black bars at the top and bottom of the screen, like a movie screen) are shown; 
- Camera will be locked at ANCHOR POINT for a custom amount of time, before it gets released again;
- After release, camera goes back to previous state; letterbox bars are removed and player regains controls of hero;
- It is possible to set a given cutscene trigger to be permanently destroyed after its first usage.

The cutscene system may also be implemented without the trigger object, following events like opening [[Switches and Doors|doors]].

---

### Example
![[camera_forbidden_zone_3.png]]

Above a mockup scheme in which hero is collided with floor (light-blue solids) and moving towards a pit. Here's what should happen:

- Camera (orange square) "collides" with FORBIDDEN ZONES (dashed dark-blue lines), being unable to move past those lines;
- When hero (black circle) overlaps IGNORE THRESHOLD (dashed red lines), camera is allowed to ignore FORBIDDEN ZONES and will lerp towards hero;
- To ensure camera will only vertically follow hero as she falls through the pit, another trigger area shown as HORIZONTAL CAMERA LOCK (pink dashed lines) is placed. While hero and CAMERA LOCK are overlapping, camera is prevented from moving horizontally.

FORBIDDEN ZONES are the only camera triggers that work relative to SCREEN position, rather than hero's position.

---

Frequently, two instances of the same type of camera trigger will overlap. When this happens, the intended mechanic is to accept the values of the last trigger the player entered, as shown below:

![[camera_lock_1.png]]

The same should apply for overlapping Camera Look-Ahead Triggers.

When a Camera Locker is set to BOTH, it should behave the same, as shown below:

![[camera_lock_2.png]]

#trigger