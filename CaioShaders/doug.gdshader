shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0, 10) = 2.0;

void fragment() {
    vec4 base_color = COLOR;
    
    vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
    
    float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
    outline = min(outline, 1.0);
    
    vec4 final_color = mix(base_color, outline_color, outline - base_color.a);
    COLOR = final_color;
}