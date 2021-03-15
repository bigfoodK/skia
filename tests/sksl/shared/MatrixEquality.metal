#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
struct Uniforms {
    float4 colorGreen;
    float4 colorRed;
    float2x2 testMatrix2x2;
    float3x3 testMatrix3x3;
};
struct Inputs {
};
struct Outputs {
    float4 sk_FragColor [[color(0)]];
};
thread bool operator==(const float2x2 left, const float2x2 right) {
    return all(left[0] == right[0]) && all(left[1] == right[1]);
}
thread bool operator==(const float3x3 left, const float3x3 right) {
    return all(left[0] == right[0]) && all(left[1] == right[1]) && all(left[2] == right[2]);
}
thread bool operator!=(const float2x2 left, const float2x2 right) {
    return any(left[0] != right[0]) || any(left[1] != right[1]);
}
thread bool operator!=(const float3x3 left, const float3x3 right) {
    return any(left[0] != right[0]) || any(left[1] != right[1]) || any(left[2] != right[2]);
}

bool test_equality(Uniforms _uniforms) {
    bool ok = true;
    ok = ok && _uniforms.testMatrix2x2 == float2x2(float2(1.0, 2.0), float2(3.0, 4.0));
    ok = ok && _uniforms.testMatrix3x3 == float3x3(float3(1.0, 2.0, 3.0), float3(4.0, 5.0, 6.0), float3(7.0, 8.0, 9.0));
    ok = ok && _uniforms.testMatrix2x2 != float2x2(100.0);
    ok = ok && _uniforms.testMatrix3x3 != float3x3(float3(9.0, 8.0, 7.0), float3(6.0, 5.0, 4.0), float3(3.0, 2.0, 1.0));
    return ok;
}
fragment Outputs fragmentMain(Inputs _in [[stage_in]], constant Uniforms& _uniforms [[buffer(0)]], bool _frontFacing [[front_facing]], float4 _fragCoord [[position]]) {
    Outputs _out;
    (void)_out;
    _out.sk_FragColor = test_equality(_uniforms) ? _uniforms.colorGreen : _uniforms.colorRed;
    return _out;
}
