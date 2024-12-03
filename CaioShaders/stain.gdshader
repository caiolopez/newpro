shader_type canvas_item;
uniform vec4 custom_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;
uniform float threshold : hint_range(0.0, 1.0) = 0.5; // Adjustable threshold for what's considered "light"

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 texture_color = texture(TEXTURE, UV);
    
    // Calculate brightness (you can adjust the weights for different effects)
    float brightness = (screen_color.r + screen_color.g + screen_color.b) / 3.0;
    
    // If brightness is above threshold, invert the color, otherwise make it transparent
    if (brightness > threshold) {
        COLOR = vec4(custom_color.rgb, texture_color.a);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}