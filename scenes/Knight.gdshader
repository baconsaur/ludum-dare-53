shader_type canvas_item;

uniform bool active = false;
uniform float alpha = 1.0;
uniform vec4 skin_base = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 skin_shading = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 blush = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 eyes = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 underwear = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 top_base = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 coat_of_arms = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 sleeves_pants = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 flash_color = vec4(1.0, 1.0, 1.0, previous_color.a * alpha);
	vec4 new_color = previous_color;
	
	if (previous_color == vec4(1.0, 0.0, 1.0, 1.0)) {
		new_color = skin_base;
	} else if (previous_color == vec4(0.0, 0.0, 1.0, 1.0)) {
		new_color = skin_shading;
	} else if (previous_color == vec4(1.0, 1.0, 0.0, 1.0)) {
		new_color = eyes;
	} else if (previous_color == vec4(0.0, 0.0, 0.0, 1.0)) {
		new_color = underwear;
	} else if (previous_color == vec4(1.0, 1.0, 1.0, 1.0)) {
		new_color = skin_base * blush;
	} else if (previous_color == vec4(0.0, 1.0, 1.0, 1.0)) {
		new_color = top_base;
	} else if (previous_color == vec4(1.0, 0.0, 0.0, 1.0)) {
		new_color = coat_of_arms;
	} else if (previous_color == vec4(0.0, 1.0, 0.0, 1.0)) {
		new_color = sleeves_pants;
	}
	
	if (active == true)
	{
		new_color = flash_color
	}
	COLOR = new_color;
}