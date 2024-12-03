// Simple 2D dissolve by godotshaders (CC0) - https://godotshaders.com/shader/simple-2d-dissolve/
// Updated to Godot 4.0

shader_type canvas_item;
 
uniform sampler2D dissolve_texture : filter_nearest;
uniform float dissolve_value : hint_range(0,1);
uniform vec4 custom_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float blend_factor : hint_range(0,1);

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 secondary_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);

    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
    secondary_texture.rgb = custom_color.rgb;
    secondary_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
    vec4 blended_texture = mix(main_texture, secondary_texture, blend_factor);

    COLOR = blended_texture;
}
