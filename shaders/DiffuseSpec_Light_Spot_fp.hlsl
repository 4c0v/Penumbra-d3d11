#include "d3d11_common.hlsli"
#include "d3d11_ggx.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);
SAMPLER2D(spotlightMap, 4);
SAMPLER1D(spotNegRejectMap, 5);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,
          float3 halfVec : TEXCOORD2,
          float3 spotlightUv : TEXCOORD3,

          out float4 oColor : SV_Target)
{
	float3 diffuse = TEX2D(diffuseMap, uv).xyz;
	float3 lightNormal = normalize(lightDir);
	float3 halfNormal = normalize(halfVec);
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float4 spotColor = TEX2DPROJ(spotlightMap, spotlightUv);
	float rejectNeg = TEX1D(spotNegRejectMap, spotlightUv.z + 0.5).x;
	float specular = saturate(dot(halfNormal, float3(0, 0, 1)));
	specular = GGXSpec(float3(0, 0, 1), lightNormal, halfNormal) * lightColor.w * spotColor.w;
	oColor.xyz = specular + diffuse * saturate(dot(lightNormal, float3(0, 0, 1))) * lightColor.xyz * spotColor.xyz;
	oColor.xyz *= attenuation * rejectNeg;
	oColor.w = 0;
}
