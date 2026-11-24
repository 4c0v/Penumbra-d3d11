#ifndef HPL_D3D11_GGX_HLSLI
#define HPL_D3D11_GGX_HLSLI

#define GGX_ROUGHNESS 0.45
#define GGX_F0        0.25
#define GGX_GAIN      2.0

float GGXSpec(float3 N, float3 L, float3 H)
{
	float NL = saturate(dot(N, L));
	float NH = saturate(dot(N, H));
	float LH = saturate(dot(L, H));
	float3 V = 2.0 * dot(L, H) * H - L;
	float NV = max(saturate(dot(N, V)), 0.05);

	float a = GGX_ROUGHNESS * GGX_ROUGHNESS;
	float a2 = a * a;
	float d = NH * NH * (a2 - 1.0) + 1.0;
	float D = a2 / (3.14159265 * d * d);
	float k = a * 0.5;
	float G = (NL / (NL * (1.0 - k) + k)) * (NV / (NV * (1.0 - k) + k));
	float F = GGX_F0 + (1.0 - GGX_F0) * pow(1.0 - LH, 5.0);

	return GGX_GAIN * D * G * F / (4.0 * NV);
}
#endif
