#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
float3 ambientColor;

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	oColor = TEX2D(diffuseMap, uv);
	oColor.xyz *= ambientColor;
}
