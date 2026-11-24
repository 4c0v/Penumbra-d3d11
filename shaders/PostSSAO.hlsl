cbuffer C : register(b0)
{
	float4 gProj;
	float4 gParams;
	float4 gScreen;
};

#ifdef MSAA
Texture2DMS<float> gDepth : register(t0);
#else
Texture2D<float> gDepth : register(t0);
#endif
Texture2D<float> gAo : register(t1);

struct VSOut { float4 pos : SV_Position; };

VSOut VSMain(uint id : SV_VertexID)
{
	VSOut o;
	float2 t = float2((id << 1) & 2, id & 2);
	o.pos = float4(t * float2(2, -2) + float2(-1, 1), 0, 1);
	return o;
}

float Depth(int2 p)
{
	p = clamp(p, int2(0, 0), int2(gScreen.xy) - 1);
#ifdef MSAA
	return gDepth.Load(p, 0);
#else
	return gDepth.Load(int3(p, 0));
#endif
}

float EyeZ(float d)
{
	float ndcz = d * 2.0 - 1.0;
	return -gProj.w / (ndcz + gProj.z);
}

float3 ViewPos(int2 p, float d)
{
	float z = EyeZ(d);
	float2 ndc = float2((p.x + 0.5) * gScreen.z * 2.0 - 1.0, 1.0 - (p.y + 0.5) * gScreen.w * 2.0);
	return float3(ndc.x * (-z) / gProj.x, ndc.y * (-z) / gProj.y, z);
}

static const int kBayer[16] = { 0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5 };
#define SAMPLES 16

float PSAo(VSOut i) : SV_Target
{
	int2 p = int2(i.pos.xy);
	float d = Depth(p);
	if(d >= 0.99999) return 1.0;
	float3 Pc = ViewPos(p, d);
	float3 Pr = ViewPos(p + int2( 1, 0), Depth(p + int2( 1, 0)));
	float3 Pl = ViewPos(p + int2(-1, 0), Depth(p + int2(-1, 0)));
	float3 Pu = ViewPos(p + int2(0, -1), Depth(p + int2(0, -1)));
	float3 Pd = ViewPos(p + int2(0,  1), Depth(p + int2(0,  1)));
	float3 dx = (abs(Pr.z - Pc.z) < abs(Pl.z - Pc.z)) ? (Pr - Pc) : (Pc - Pl);
	float3 dy = (abs(Pd.z - Pc.z) < abs(Pu.z - Pc.z)) ? (Pd - Pc) : (Pc - Pu);
	float3 N = normalize(cross(dx, dy));
	if(dot(N, Pc) > 0.0) N = -N;

	float3 T = normalize(abs(N.y) < 0.99 ? cross(N, float3(0, 1, 0)) : cross(N, float3(1, 0, 0)));
	float3 B = cross(N, T);

	float rot = (kBayer[(p.x & 3) + (p.y & 3) * 4] / 16.0) * 6.2831853;
	float radius = gParams.x;
	float occ = 0.0;

	[unroll]
	for(int k = 0; k < SAMPLES; ++k)
	{
		float h = (k + 0.5) / SAMPLES;
		float a = k * 2.3999632 + rot;
		float r = sqrt(1.0 - h * h);
		float3 dir = T * (cos(a) * r) + B * (sin(a) * r) + N * h;
		float scale = lerp(0.15, 1.0, h * h);
		float3 sp = Pc + dir * radius * scale;
		if(sp.z > -0.05) continue;

		float4 clip = float4(sp.x * gProj.x, sp.y * gProj.y, sp.z * gProj.z + gProj.w, -sp.z);
		float2 ndc = clip.xy / clip.w;
		int2 sp2 = int2((ndc.x * 0.5 + 0.5) * gScreen.x, (0.5 - ndc.y * 0.5) * gScreen.y);
		float sd = Depth(sp2);
		float sceneZ = (sd >= 0.99999) ? -1e5 : EyeZ(sd);

		float diff = sceneZ - sp.z;
		float range = saturate(radius / max(abs(Pc.z - sceneZ), 1e-4));
		occ += (diff > gParams.z ? 1.0 : 0.0) * range;
	}
	float ao = 1.0 - occ / SAMPLES;
	return saturate(ao * ao * 0.5 + ao * 0.5 + 0.0);
}

float4 PSBlur(VSOut i) : SV_Target
{
	int2 p = int2(i.pos.xy);
	float d0 = Depth(p);
	if(d0 >= 0.99999) return float4(1, 1, 1, 1);
	float z0 = EyeZ(d0);

	float sum = 0.0, wsum = 0.0;
	[unroll] for(int y = -2; y < 2; ++y)
	[unroll] for(int x = -2; x < 2; ++x)
	{
		int2 q = clamp(p + int2(x, y), int2(0, 0), int2(gScreen.xy) - 1);
		float zq = EyeZ(Depth(q));
		float w = 1.0 / (0.01 + abs(zq - z0) * 8.0);
		sum += gAo.Load(int3(q, 0)) * w;
		wsum += w;
	}
	float ao = sum / max(wsum, 1e-4);
	ao = lerp(1.0, ao, saturate(gParams.y));
	return float4(ao, ao, ao, 1.0);
}
