shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx, blend_add;

uniform float shininess = 200;
void vertex() {
	// Called for every vertex the material is visible on.
	//if (VERTEX > 0.0){
		//VERTEX += vec3(sin(TIME * 0.5) * .2);
	//}
	VERTEX.y += sin(TIME * 5.0 + VERTEX.x * 0.1) * 0.1;
	//VERTEX.x += sin(TIME * 5.0 + VERTEX.x * 1.0) * 0.2;
	//VERTEX.x += sin(TIME * 5.0 + VERTEX.x * 1.0) * 0.2;
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));

	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fragment() {
	//Called for every pixel the material is visible on
	ALPHA = 0.3;
	if (UV.y > 0.5){
		ALBEDO = vec3(0,0.2,0);
		ROUGHNESS = 1.0;
		RIM = 0.5;
	}
	else{
		ALBEDO = vec3(0,0.2,0);
		ROUGHNESS = 1.0;
		RIM = 0.5;
	}

	vec3 color;
	color.r = sin(TIME * 2.0 + VERTEX.x);
	color.g = sin(TIME * 4.0 + VERTEX.y);
	color.b = sin(TIME * 6.0 + VERTEX.z);
	ALBEDO = color;
	RIM = 0.5;
	//EMISSION += ALBEDO *  (sin(TIME * 2.0 + VERTEX.x) + 1.0);
	//vec2 rotated_uv = rotate(UV, vec2(0.5), TIME);
}

//void light() {
	////transparent  glass look
	//vec3 half_vec = normalize(VIEW + LIGHT);
	//float n_dot_half = max(0.0, dot(NORMAL, half_vec));
	//float pf = pow(n_dot_half, shininess * SPECULAR_AMOUNT);
	//
	//SPECULAR_LIGHT += pf * ATTENUATION;
	//ALPHA += pf * ATTENUATION;
//
//}
