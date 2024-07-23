shader_type canvas_item;

uniform vec4 replace_black : source_color;
uniform vec4 replace_white : source_color;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec3 new_color = mix(replace_black.rgb, replace_white.rgb, color.r);
    COLOR = vec4(new_color, color.a);
}