![[region_label.png]]

- REGION LABEL show custom text regarding the name of the region hero is entering;
- The amount of time the REGION LABEL is shown must be easy to fine-tune -- only one variable for all REGION LABELS, as on-screen time should be equal for all of them;
- REGION LABELS animate in and out, like the pause menu bars;

REGION LABEL TRIGGER

- REGION LABELS are triggered when hero overlaps REGION LABEL TRIGGER;
- If the overlapped REGION LABEL TRIGGER value is different from the "CurrentRegion" variable, then CurrentRegion = REGION LABEL TRIGGER, and the game will display REGION LABEL (CurrentRegion);
- If the overlapped REGION LABEL TRIGGER = CurrentRegion, nothing happens;

#trigger