#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);
SAMPLER2D(spotlightMap, 4);
SAMPLER1D(spotNegRejectMap, 5);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,
          float3 spotlightUv : TEXCOORD2,

          out float4 oColor : SV_Target)
{
	float3 diffuse = TEX2D(diffuseMap, uv).xyz;
	float3 lightNormal = normalize(lightDir);
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float3 spotColor = TEX2DPROJ(spotlightMap, spotlightUv).xyz;
	float rejectNeg = TEX1D(spotNegRejectMap, spotlightUv.z + 0.5).x;
	oColor.xyz = diffuse * saturate(dot(lightNormal, float3(0, 0, 1))) * attenuation * lightColor.xyz * spotColor * rejectNeg;
	oColor.w = 0;
}
