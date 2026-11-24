#include "d3d11_common.hlsli"

SAMPLER2D(NormalMap, 0);
SAMPLER2D(LightMap, 1);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float3 uv : TEXCOORD0,
          float3 LightDir : TEXCOORD1,
          float3 HalfVec : TEXCOORD2,
          float2 ScreenPos : TEXCOORD3,

          out float4 oColor : SV_Target)
{
	float4 BumpVec = (1 - 2 * TEX2D(NormalMap, uv.xy));
	float4 LightCol = TEX2D(LightMap, ScreenPos);
	BumpVec.xyz = normalize(BumpVec.xyz);
	float Diffuse = dot(normalize(LightDir), BumpVec.xyz) * LightCol.x;
	float Specular = dot(normalize(HalfVec), BumpVec.xyz);
	Specular = pow(max(Specular, 0), 24) * BumpVec.w * color.w;
	oColor.xyz = Diffuse * color.xyz;
	oColor.w = Specular * LightCol.x;
}
