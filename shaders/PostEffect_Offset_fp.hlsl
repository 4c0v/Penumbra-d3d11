#include "d3d11_common.hlsli"

SAMPLER2D(ScreenBuffer, 0);

void main(float4 pos : SV_Position,
          float3 uv : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	oColor = TEX2D(ScreenBuffer, uv.xy);
}
