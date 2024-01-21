Shader "Custom/HeatDistortion"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 1)) = 0.5
        _ColorIntensity ("Color Intensity", Range(0, 1)) = 0.5
        _DustNoiseTex ("Glare Noise Texture", 2D) = "white" {}

        _FarClip ("Far Clip", Float) = 10
        _NearClip ("Near Clip", Float) = 2
        _HeightStep ("Height Step", Float) = 0.1
        _HeightOffset ("Height Offset", Float) = 0.1
        _DustSpeed ("Dust Speed", Float) = 0.1
        _HeatDistortSpeed ("Heat Distort Speed", Float) = 0.1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            sampler2D _DustNoiseTex;
            float _Intensity;
            float _ColorIntensity;

            float _FarClip;
            float _NearClip;
            float _HeightStep;
            float _HeightOffset;
            float _DustSpeed;
            float _HeatDistortSpeed;

            sampler2D _CameraDepthTexture;
            float4 _CameraDepthTexture_TexelSize;
            float4 _CameraDepthTexture_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            inline float MyLinearEyeDepth(float z)
            {
                return _NearClip / (_ZBufferParams.x * z / _FarClip + _ZBufferParams.y); //10 is the far clip plane of the camera and 2.0 is the near clip plane
            }

            float Random(float2 uv)
            {
                return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float heightFactor = smoothstep(1.0 - (_HeightStep * uv.y), _HeightOffset, uv.y);

                // Sample the depth and noise texture
                float rawDepth = tex2D(_CameraDepthTexture, i.uv).r;
                float depth = MyLinearEyeDepth(rawDepth);
                float noiseValue = tex2D(_NoiseTex, uv - (_Time.y * _HeatDistortSpeed)).rgb * _Intensity * depth /10;

                // Sample the glare noise texture
                float3 dustNoise = tex2D(_DustNoiseTex, uv * 0.5 - _Time.y * _DustSpeed).rgb * depth; // Adjust UV scaling and speed as needed
                float dustIntensity = saturate(heightFactor * length(dustNoise) - 0.02) * 5; // Adjust thresholds as needed
                float4 dustColor = float4(1, 1, 1, 1) * dustIntensity; // White dust

                // Sample the main texture with the distorted UVs
                float4 color = tex2D(_MainTex, uv + heightFactor * length(noiseValue));

                // Add glare to the color

                color.rgb = lerp(color.rgb, color.rgb + float3(.75, .35, .35), pow(depth,2) * heightFactor * 2);

                color += dustColor;

                return color;
            }
            ENDCG
        }
    }
}