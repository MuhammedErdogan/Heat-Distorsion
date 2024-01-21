Shader "Custom/HeatDistortionWithDepth"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DistortionTex ("Distortion Texture", 2D) = "white" {}
        _Distortion ("Distortion", Range(0, 1)) = 0.1
        _Speed ("Speed", Range(0, 1)) = 1
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
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            
            sampler2D _DistortionTex;
            
            sampler2D _CameraDepthTexture;
            float4 _CameraDepthTexture_TexelSize;
            float4 _CameraDepthTexture_ST;
            
            float _Distortion;
            float _Speed;

            float4x4 clipToWord;

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
                return o;
            }

            inline float MyLinearEyeDepth(float z)
            {
                return 3.0 / (_ZBufferParams.x * z + _ZBufferParams.y);
            }

            // half2 WorldToScreenPos(half3 pos)
            // {
            //     pos = normalize(pos - _WorldSpaceCameraPos) * (_ProjectionParams.y + (_ProjectionParams.z - _ProjectionParams.y)) + _WorldSpaceCameraPos;
            //     half2 uv = 0;
            //     float3 toCam = mul(unity_WorldToCamera, pos);
            //     float camPosZ = toCam.z;
            //     float height = 2* camPosZ / unity_CameraProjection._11;
            //     float width = _ScreenParams.x / _ScreenParams.y * height;
            //     uv.x = (toCam.x + width * 0.5) / width;
            //     uv.y = (toCam.y + height * 0.5) / height;
            //     return uv;
            // }

            float4 frag(v2f i) : SV_Target
            {
                // receive depth from camera
                float rawDepth = tex2D(_CameraDepthTexture, i.uv).r;
                float zeroOneDepth = Linear01Depth(rawDepth);

                float depth = tex2D(_CameraDepthTexture, i.uv).r;
                // float4 posCS = float4(i.uv * 2.0 - 1.0, depth, 1);
                // float4 posInvProj = mul(clipToWord, posCS);
                // float3 posWS = posInvProj.xyz / posInvProj.w;
                //
                // posWS.z -= 100;
                //
                // float2 newUV = WorldToScreenPos(posWS);

                //calculate distortion strength with depth
                float distortionStrength = _Distortion / depth;

                //calculate distortion UV with distortion strength
                float2 distortionUV = tex2D(_DistortionTex, i.uv * _Speed + _Time.y).rgb;

                // apply distortion to main texture
                float4 color = tex2D(_MainTex, i.uv + distortionUV * distortionStrength);
                return color;
            }
            ENDCG
        }
    }
}