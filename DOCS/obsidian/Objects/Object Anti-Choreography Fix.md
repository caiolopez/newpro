Objects that have the same animation, when starting all at the same time, tend to move all at the same time, which looks unrealistic and ugly.

Randomizing their starting position within the animation cycle would fix the visuals, but would hurt the gameplay determinism.

The solution I found is cheap and effective. Let's use the object's Y and X position to offset the animation cycle! Any algorithm will work, for instance, https://en.wikipedia.org/wiki/Digit_sum