#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	float width;
	float height;
	float radius;
	float padding;
	vec4 frame_color;
} ubuf;

// From https://github.com/marklundin/glsl-sdf-primitives/blob/master/udRoundBox.glsl
float udRoundBox(vec3 p, vec3 b, float r)
{
	return length(max(abs(p) - b, 0.0)) - r;
}

void main()
{
	float THRESHOLD = 0.0001;
	vec2 size = vec2(ubuf.width, ubuf.height) / 2;

	vec4 color = texture(source, qt_TexCoord0);
	vec3 box_pos = vec3(size.x, size.y, 0.0);
	vec3 box_size = vec3(size.x - ubuf.padding, size.y - ubuf.padding, 0.0);

	vec3 pos = vec3(qt_TexCoord0 * vec2(ubuf.width, ubuf.height), 0.0);
	float dist = udRoundBox(pos - box_pos, box_size, ubuf.radius);
	if (dist <= THRESHOLD)
		fragColor = vec4(color.xyz, 1.0) * ubuf.qt_Opacity;
	else
		fragColor = vec4(ubuf.frame_color.xyz, 1.0) * ubuf.qt_Opacity;
}
