#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float timeCount;

void main(float4 position : POSITION,
          float3 color : COLOR0,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float3 oUv : TEXCOORD0)
{
	float amp = 0.04;
	float freq = 15;
	float speed = 3;
	float4 p = mul(worldViewProj, position);
	p.y += sin(timeCount * speed + (position.x) * freq) * amp;
	p.y += sin(timeCount * speed + (position.z) * freq) * amp;
	oPosition = GLClip(p);
	oColor = color;
	oUv = uv;
}
