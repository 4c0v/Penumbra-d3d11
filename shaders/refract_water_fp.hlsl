#include "d3d11_common.hlsli"

SAMPLERRECT(screenMap, 0);
SAMPLER2D(refractMap, 1);
SAMPLER2D(diffuseMap, 2);

float2 screenSize;
float scale;
float t;

void main(float4 inPos : SV_Position,
          float4 color : COLOR0,
          float2 uv : TEXCOORD0,
          float3 normal : TEXCOORD1,
          float3 eyePos : TEXCOORD2,

          out float4 oColor : SV_Target)
{
	float2 wpos = GLWPos(inPos, screenSize.y);

	float2 uv_offset1 = uv;
	uv_offset1.x += sin(t * 0.8 + uv.y * 10) * 0.04;
	uv_offset1.y += sin(t * 0.8 + uv_offset1.x * 10) * 0.04;
	float3 offset1 = ((TEX2D(refractMap, uv_offset1).xyz * 2) - 1);

	float2 uv_offset2 = uv;
	uv_offset2.x += sin(t * -2.6 + uv.y * 12) * 0.03;
	uv_offset2.y += sin(t * -2.6 + uv_offset2.x * 12) * 0.03;

	float3 offset2 = ((TEX2D(refractMap, uv_offset2).xyz * 2) - 1);
	offset2.xy = -offset2.xy;

	float3 offset = normalize(offset1 * 0.7 + offset2 * 0.3);

	float3 waterColor = TEX2D(diffuseMap, uv_offset1).xyz;

	float4 screenColor = TEXRECT(screenMap, wpos + offset.xy * -scale);
	if(screenColor.w < 0.5) screenColor = TEXRECT(screenMap, wpos);

	oColor.xyz = screenColor.xyz * waterColor;
	oColor.xyz *= saturate(dot(float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0), offset)) * 0.5 + 0.5;
	oColor.xyz += pow(saturate(dot(float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0), offset)), 8) * 5;
	oColor.w = 1;
}
