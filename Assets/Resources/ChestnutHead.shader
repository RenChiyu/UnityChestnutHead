Shader "ChestnutHead"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull back
        Lighting Off
        ZTest LEqual
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

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
            float4 _MainTex_ST;
            float4x4 _TRSMatrix;


            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // 平面变换为球
                float theta = v.uv.x * UNITY_TWO_PI;
                float phi = v.uv.y * UNITY_PI;
                float x1 = sin(phi) * cos(theta);
                float y1 = sin(phi) * sin(theta);
                float z1 = cos(phi);

                // 应用旋转矩阵
                float4 p = mul(_TRSMatrix, float4(x1, y1, z1, v.vertex.w));
                x1 = p.x;
                y1 = p.y;
                z1 = p.z;

                // 计算出投影后的坐标
                p.x = -x1 / (y1 - 1);
                p.y = 0;
                p.z = -z1 / (y1 - 1);

                o.vertex = UnityObjectToClipPos(p);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
