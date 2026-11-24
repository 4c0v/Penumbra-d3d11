#include "d3d11_common.hlsli"

SAMPLER2D(NormalMap, 0);
SAMPLER2D(LightMap, 1);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float3 uv : TEXCOORD0,
          float3 LightDir : TEXCOORD1,
          float2 ScreenPos : TEXCOORD2,

          out float4 oColor : SV_Target)
{
	float4 BumpVec = (1 - 2 * TEX2D(NormalMap, uv.xy));
	float4 LightCol = TEX2D(LightMap, ScreenPos);
	float Diffuse = dot(LightDir, BumpVec.xyz) * LightCol.x;
	oColor.xyz = Diffuse * color.xyz;
	oColor.w = 0;
}
