#version 440

#define PI 3.1415926538

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	float stripe_width;
	float angle;
	vec4 color1;
	vec4 color2;
} ubuf;


mat2 rot_mat(float angle)
{
	return mat2(cos(angle), -sin(angle),
		    sin(angle),  cos(angle));
}

void main()
{
	vec2 uv = qt_TexCoord0 * rot_mat((ubuf.angle * PI) / 180);
	// Using ceil(sin(uv.x * ubuf.stripe_width)) causes some small
	// artifacts, probably due to rounding effects. Use abs instead and use
	// a smaller step to account for larger gaps due to the negative portion
	// being wiped. This also doubles our frequncy so we mutiply by a 1/2 to
	// return back to what it usually is
	float f = step(0.35, 1.0 - abs(sin(0.5 * uv.x * ubuf.stripe_width)));
	fragColor = mix(ubuf.color1, ubuf.color2, f);
}
