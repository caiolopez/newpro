//shader_type canvas_item;
//uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
//uniform float pixel_size: hint_range(1.0, 100.0) = 8.0;
//
//void fragment() {
    //vec2 uv = SCREEN_UV;
    //vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    //vec2 pixelated_uv = round(uv * screen_size / pixel_size) * pixel_size / screen_size;
    //COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
//}

shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size: hint_range(1.0, 100.0) = 8.0;
uniform float gap_size: hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));

    // Calculate pixel coordinates
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;

    if (gap_size > 0.0) {
        // Calculate position within each pixel (0 to 1)
        vec2 pixel_position = fract(uv * screen_size / pixel_size);

        // If we're in the gap area, make it black
        if (pixel_position.x < gap_size || pixel_position.x > (1.0 - gap_size) ||
            pixel_position.y < gap_size || pixel_position.y > (1.0 - gap_size)) {
            COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Black gaps
        } else {
            COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
        }
    } else {
        // When gap_size is 0, just use the pixelated texture directly
        COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
    }
}