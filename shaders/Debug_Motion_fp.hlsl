#include "d3d11_common.hlsli"

float which;

void main(float4 inPos : SV_Position,
          float3 inColor : COLOR0,
          float4 inVtxPos : TEXCOORD0,
          float4 inPrevVtxPos : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	float2 p1 = inVtxPos.xy / inVtxPos.w;
	float2 p2 = inPrevVtxPos.xy / inPrevVtxPos.w;
	if(which < 0.5) oColor = float4(0.5 + 0.5 * p1, 0.5 * inVtxPos.w, 1);
	else if(which < 1.5) oColor = float4(0.5 + 0.5 * p2, 0.5 * inPrevVtxPos.w, 1);
	else oColor = float4(0.5 + 0.25 * (p2 - p1), 0.5, 1);
}
