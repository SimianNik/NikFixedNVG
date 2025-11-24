// ---------------------------------------------------------------
// Original file's content (as of 2.9.21.16552). In case of no backup?
// ---------------------------------------------------------------
/*
    #ifndef _NVD_COMMON_
    #define _NVD_COMMON_

    #include "common/context.hlsl"

    #define MASK_SIZE (1.0/0.8)

    float getMask(float2 c, float mul)
    {
        return saturate(mul*(1 - sqrt(dot(c, c))));
    }

    float2 calcMaskCoord(float2 projPos)
    {
        return float2((projPos.x - gNVDpos.x) * gNVDaspect, projPos.y - gNVDpos.y) * MASK_SIZE;
    }

    float getNVDMask(float2 projPos) {
        float2 uvm = calcMaskCoord(projPos);
        return getMask(uvm, 10);
    }

    float getMask2(float d, float mul)
    {
        return 1 - saturate(mul * (1 - d));
    }

    float2 calcMaskCoord2(float2 projPos)
    {
        float4 vp = mul(float4(projPos, 1, 1), gProjInv);
        float3 vp3 = normalize(vp.xyz / vp.w);
        float mul = sqrt(gNVDmul);
        return float2(dot(gNVDdir, vp3) * gNVDmul, sqrt(1.0 - 1.0 / (gNVDmul * gNVDmul)));
    }

    float getNVDMask2(float2 projPos)
    {
        float2 d = calcMaskCoord(projPos);
        return getMask(d.x, 10 * d.x / d.y);
    }

    #endif
*/

// ---------------------------------------------------------------
// Modification Start
// ---------------------------------------------------------------
#ifndef _NVD_COMMON_
#define _NVD_COMMON_

#include "common/context.hlsl"

// ---------------------------------------------------------------
// User-Controllable Parameters
// ---------------------------------------------------------------

// Vertical offset of the NVG mask. The game by default puts the mask a bit upwards on the screen
float NVD_OFFSET_VERT = 0.0;

// Horizontal/vertical stretch of the NVG mask.
// 1.0 = perfect circle.
float NVD_OVAL_X = 1.15;  
float NVD_OVAL_Y = 0.90;

// NVG "size" (screen space).
float NVD_SIZE = 0.5; //~0.5  = arround a 45° FOV coverage. Larger = bigger NVG mask | Smaller = tighter NVG mask.

// Clamp limits (prevent mask from becoming too big or too small)
float NVD_MAX_SCALE = 2;   // max on-screen scale when increasing the game's FOV (Zoomed out)
float NVD_MIN_SCALE = 0.5; // min on-screen scale when decreasing the game's FOV (Zoomed in)

#define MASK_SIZE (1.0 / 0.8)

float getMask(float2 c, float mul)
{
    return saturate(mul * (1 - sqrt(dot(c, c))));
}

// ---------------------------------------------------------------
// Main NVG Mask Coordinate Function
// ---------------------------------------------------------------
float2 calcMaskCoord(float2 projPos)
{
    // Compute vertical FOV
    float fovY = 2.0 * atan(1.0 / gProj._22);

    // "World static" scale. What makes the mask independent-ish of zoom. Known bug: It does change slightly with zoom. Higher camera FOV's (Zoom out) result in a slightly smaller "Green circle"
    float staticScale = tan(fovY * 0.5);

    // Clamp zoom scaling so the mask never grows/shrinks 
    staticScale = clamp(staticScale, NVD_MIN_SCALE, NVD_MAX_SCALE);

    // Adjust origin to NVG center
    float dx = projPos.x - gNVDpos.x;
    float dy = projPos.y - (gNVDpos.y + NVD_OFFSET_VERT);

    // Apply oval shaping
    float2 uv = float2(
        dx * gNVDaspect * NVD_OVAL_Y,   // swapped intentionally
        dy * NVD_OVAL_X
    );

    // Final mask coordinate
    return uv * (MASK_SIZE * staticScale / NVD_SIZE);
}

float getNVDMask(float2 projPos) {
    float2 uvm = calcMaskCoord(projPos);
    return getMask(uvm, 10);
}

float getMask2(float d, float mul)
{
    return 1 - saturate(mul * (1 - d));
}

float2 calcMaskCoord2(float2 projPos)
{
    float4 vp = mul(float4(projPos, 1, 1), gProjInv);
    float3 vp3 = normalize(vp.xyz / vp.w);
    float mul = sqrt(gNVDmul);
    return float2(dot(gNVDdir, vp3) * gNVDmul, sqrt(1.0 - 1.0 / (gNVDmul * gNVDmul)));
}

float getNVDMask2(float2 projPos)
{
    float2 d = calcMaskCoord(projPos);
    return getMask(d.x, 10 * d.x / d.y);
}

#endif
