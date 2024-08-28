shader_type canvas_item;

uniform vec4 replace_black : source_color;
uniform vec4 replace_white : source_color;
uniform float threshold : hint_range(0.0, 0.1) = 0.01;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Check for pure black (allowing for a small threshold)
    if (length(color.rgb) <= threshold) {
        COLOR = vec4(replace_black.rgb, color.a);
    }
    // Check for pure white (allowing for a small threshold)
    else if (length(color.rgb - vec3(1.0, 1.0, 1.0)) <= threshold) {
        COLOR = vec4(replace_white.rgb, color.a);
    }
    // For all other colors, keep the original
    else {
        COLOR = color;
    }
}