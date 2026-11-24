#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float fogStart;
float fogEnd;
float timeCount;

void main(float4 position : POSITION,
          float4 color : COLOR0,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float oFogUv : TEXCOORD1)
{
	float amp = 0.04;
	float freq = 15;
	float speed = 3;
	float4 p = mul(worldViewProj, position);
	p.y += sin(timeCount * speed + (position.x) * freq) * amp;
	p.y += sin(timeCount * speed + (position.z) * freq) * amp;

	oUv = uv;
	oFogUv = (fogEnd - p.z) / (fogEnd - fogStart);
	oColor = color;
	oPosition = GLClip(p);
}
