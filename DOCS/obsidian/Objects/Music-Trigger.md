An object that bears the name of the music that should be currently playing. Upon being overlapped by hero, changes the current music to the one it points to.

Special Rules:
- If hero touches a trigger for a music that is already playing, nothing happens;
- If hero touches a trigger for a music that is different than the one currently playing, the previous one should fade out completely before the next one starts (without any fade in);
- A trigger can be set to *silence*, forcing the game to fade out previous music but not playing anything afterwards.

#trigger