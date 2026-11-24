#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float3 lightNormal = normalize(lightDir);
	oColor.xyz = attenuation * TEX2D(diffuseMap, uv).xyz * lightColor.xyz * saturate(dot(lightNormal, float3(0, 0, 1)));
	oColor.w = 0;
}
