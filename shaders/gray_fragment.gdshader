shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    COLOR.rgb = mix(
		vec3(dot(tex_color.rgb, vec3(0.299, 0.587, 0.114))),
		tex_color.rgb,
		0.3
	);
	COLOR.a = tex_color.a;
}
