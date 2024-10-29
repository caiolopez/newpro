shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size: hint_range(1.0, 100.0) = 8.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 pixelated_uv = round(uv * screen_size / pixel_size) * pixel_size / screen_size;
    COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}