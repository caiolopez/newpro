Basically the same as Necropshere's:
https://youtu.be/mDfsOsDyZEk?t=305

- #### t=0s:

  - Play DEATH sound;
  - Show LETTERBOX;
  - Freeze hero position;
  - Pause hero animation;
  - Disable INPUT;
  - Shake SCREEN (Takes 0.2s) (Construct settings: 40 magnitude, reducing magnitude);
  - Paint hero WHITE;
  - Start to flicker hero VISIBLE/INVISIBLE, 0.075s visible, 0.075s;

- #### t=0.4s:

  - Unpaint hero WHITE;
  - hero respawns;
  - Screen gets BLACK;
  - Play RESPAWN sound;
  - Unpause hero animation;
  - FADE IN (takes 0.1s);
  - Camera LERPS to hero position (takes 0.2s);


- #### t=1s:
  - Stop flickering hero;
  - Hide LETTERBOX;
  - Enable INPUT;