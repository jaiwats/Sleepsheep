// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SineVFX/GalaxyMaterials/GalaxyMaterial2_Transparent" // Renamed for clarity
{
	Properties
	{
		_GlobalAlpha("Global Alpha", Range(0,1)) = 1.0 // NEW: Global transparency control
		_FinalPower("Final Power", Float) = 4
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_NormalAmount("Normal Amount", Range(0 , 1)) = 1
		[Toggle(_RIMENABLED_ON)] _RimEnabled("Rim Enabled", Float) = 1
		_RimAddOrMultiply("Rim Add Or Multiply", Range(0 , 1)) = 0
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimEmissionPower("Rim Emission Power", Float) = 1
		_RimExp("Rim Exp", Range(0.2 , 10)) = 4
		_RimExp2("Rim Exp 2", Range(0.2 , 10)) = 2
		_RimNoiseTexture("Rim Noise Texture", 2D) = "white" {}
		_RimNoiseTilingU("Rim Noise Tiling U", Float) = 1
		_RimNoiseTilingV("Rim Noise Tiling V", Float) = 1
		_RimNoiseAmount("Rim Noise Amount", Float) = -2.5
		_RimNoiseRefraction("Rim Noise Refraction", Range(0 , 1)) = 0
		_RimNoiseScrollSpeed("Rim Noise Scroll Speed", Float) = 0.1
		_RimNoiseTwistAmount("Rim Noise Twist Amount", Range(0 , 2)) = 0
		[Toggle(_RIMNOISECAENABLED_ON)] _RimNoiseCAEnabled("Rim Noise CA Enabled", Float) = 0
		_RimNoiseCAAmount("Rim Noise CA Amount", Range(0 , 0.1)) = 0.1
		_RimNoiseCAU("Rim Noise CA U", Range(0 , 1)) = 1
		_RimNoiseCAV("Rim Noise CA V", Range(0 , 1)) = 0
		_RimNoiseCARimMaskExp("Rim Noise CA Rim Mask Exp", Range(0.2 , 8)) = 4
		_RimNoiseDistortionTexture("Rim Noise Distortion Texture", 2D) = "white" {}
		_RimNoiseDistortionTilingU("Rim Noise Distortion Tiling U", Float) = 2
		_RimNoiseDistortionTilingV("Rim Noise Distortion Tiling V", Float) = 4
		_RimNoiseDistortionAmount("Rim Noise Distortion Amount", Float) = 0
		_RimNoiseSpherize("Rim Noise Spherize", Range(0 , 1)) = 0
		_RimNoiseSpherizePosition("Rim Noise Spherize Position", Vector) = (0,0,0,0)
		_Eta("Eta", Range(-1 , 0)) = -0.1
		_EtaFresnelExp("Eta Fresnel Exp", Range(1 , 8)) = 3
		_EtaFresnelExp2("Eta Fresnel Exp 2", Range(1 , 8)) = 1
		_EtaAAEdgesFix("Eta AA Edges Fix", Range(0 , 0.5)) = 0
		_RotationAxis("Rotation Axis", Vector) = (0,1,0,0)
		_RotationStars("Rotation Stars", Float) = 0
		_RotationClouds("Rotation Clouds", Float) = 0
		_RotationDarkClouds("Rotation Dark Clouds", Float) = 0
		_StarsTexture("Stars Texture", CUBE) = "white" {}
		_StarsEmissionPower("Stars Emission Power", Float) = 4
		_StarsRotationSpeed("Stars Rotation Speed", Float) = 0.1
		_CloudsTexture("Clouds Texture", CUBE) = "black" {}
		_CloudsOpacityPower("Clouds Opacity Power", Float) = 1
		_CloudsOpacityExp("Clouds Opacity Exp", Range(0.2 , 4)) = 1
		_CloudsEmissionPower("Clouds Emission Power", Float) = 1
		_CloudsRotationSpeed("Clouds Rotation Speed", Float) = 0.1
		_CloudsRamp("Clouds Ramp", 2D) = "white" {}
		_CloudsRampColorTint("Clouds Ramp Color Tint", Color) = (1,1,1,1)
		_CloudsRampOffsetExp("Clouds Ramp Offset Exp", Range(0.2 , 8)) = 1
		_CloudsRampOffsetExp2("Clouds Ramp Offset Exp 2", Range(0.2 , 8)) = 1
		[Toggle(_DARKCLOUDSENABLED_ON)] _DarkCloudsEnabled("Dark Clouds Enabled", Float) = 0
		_DarkCloudsTexture("Dark Clouds Texture", CUBE) = "white" {}
		_DarkCloudsLighten("Dark Clouds Lighten", Range(1 , 10)) = 1
		_DarkCloudsThicker("Dark Clouds Thicker", Range(0.2 , 4)) = 1
		_DarkCloudsRotationSpeed("Dark Clouds Rotation Speed", Float) = 0.1
		[Toggle]_DarkCloudsEdgesGlowStyle("Dark Clouds Edges Glow Style", Float) = 0
		_DarkCloudsEdgesGlowPower("Dark Clouds Edges Glow Power", Float) = 50
		_DarkCloudsEdgesGlowExp("Dark Clouds Edges Glow Exp", Range(0.2 , 4)) = 1
		_DarkCloudsEdgesGlowClamp("Dark Clouds Edges Glow Clamp", Range(1 , 4)) = 2
		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1
	}

		SubShader
		{
			// MODIFIED Tags for transparency
			Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off // NEW: Turn off depth writing for transparent objects

			CGINCLUDE
			#include "UnityShaderVariables.cginc"
			#include "UnityPBSLighting.cginc"
			#include "Lighting.cginc"
			#pragma target 3.0
			#pragma shader_feature _DARKCLOUDSENABLED_ON
			#pragma shader_feature _RIMENABLED_ON
			#pragma shader_feature _RIMNOISECAENABLED_ON
			#ifdef UNITY_PASS_SHADOWCASTER
				#undef INTERNAL_DATA
				#undef WorldReflectionVector
				#undef WorldNormalVector
				#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
				#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
				#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
			#endif
			struct Input
			{
				float3 worldPos;
				float3 worldNormal;
				INTERNAL_DATA
				float2 uv_texcoord;
			};

			uniform float _GlobalAlpha; // NEW: Access the global alpha property

			uniform float _FinalPower;
			uniform samplerCUBE _StarsTexture;
			uniform float3 _RotationAxis;
			uniform float _StarsRotationSpeed;
			uniform float _RotationStars;
			uniform sampler2D _NormalTexture;
			uniform float4 _NormalTexture_ST;
			uniform float _NormalAmount;
			uniform float _Eta;
			uniform float _EtaFresnelExp;
			uniform float _EtaFresnelExp2;
			uniform sampler2D _RimNoiseTexture;
			uniform float _RimNoiseTwistAmount;
			uniform float _RimNoiseTilingV;
			uniform float4 _RimNoiseSpherizePosition;
			uniform float _RimNoiseSpherize;
			uniform float _RimNoiseTilingU;
			uniform float _RimNoiseScrollSpeed;
			uniform sampler2D _RimNoiseDistortionTexture;
			uniform float _RimNoiseDistortionTilingU;
			uniform float _RimNoiseDistortionTilingV;
			uniform float _RimNoiseDistortionAmount;
			uniform float _RimNoiseAmount;
			uniform float _RimExp;
			uniform float _RimExp2;
			uniform float _RimNoiseRefraction;
			uniform float _EtaAAEdgesFix;
			uniform float _StarsEmissionPower;
			uniform float _RimNoiseCAU;
			uniform float _RimNoiseCAAmount;
			uniform float _RimNoiseCARimMaskExp;
			uniform float _RimNoiseCAV;
			uniform float _RimEmissionPower;
			uniform float4 _RimColor;
			uniform float _RimAddOrMultiply;
			uniform sampler2D _CloudsRamp;
			uniform samplerCUBE _CloudsTexture;
			uniform float _CloudsRotationSpeed;
			uniform float _RotationClouds;
			uniform float _CloudsRampOffsetExp;
			uniform float _CloudsRampOffsetExp2;
			uniform float _CloudsEmissionPower;
			uniform float4 _CloudsRampColorTint;
			uniform float _CloudsOpacityExp;
			uniform float _CloudsOpacityPower;
			uniform float _DarkCloudsEdgesGlowStyle;
			uniform samplerCUBE _DarkCloudsTexture;
			uniform float _DarkCloudsRotationSpeed;
			uniform float _RotationDarkClouds;
			uniform float _DarkCloudsEdgesGlowExp;
			uniform float _DarkCloudsEdgesGlowPower;
			uniform float _DarkCloudsEdgesGlowClamp;
			uniform float _DarkCloudsThicker;
			uniform float _DarkCloudsLighten;


			float3 RotateAroundAxis(float3 center, float3 original, float3 u, float angle)
			{
				original -= center;
				float C = cos(angle);
				float S = sin(angle);
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3(m00, m01, m02, m10, m11, m12, m20, m21, m22);
				return mul(finalMatrix, original) + center;
			}


			float3 RefractFixed797(float3 V , float3 N , float Eta , float In0)
			{
				//float d = clamp(dot(N, V) + In0, -1, 0);
				float d = abs(dot(N, V) + In0) * -1;
				float k = 1.0 - Eta * Eta * (1.0 - d * d);
				float3 R = Eta * V - (Eta * d + sqrt(k)) * N;
				return R;
			}


			float3 RefractFixed795(float3 V , float3 N , float Eta , float In0)
			{
				//float d = clamp(dot(N, V) + In0, -1, 0);
				float d = abs(dot(N, V) + In0) * -1;
				float k = 1.0 - Eta * Eta * (1.0 - d * d);
				float3 R = Eta * V - (Eta * d + sqrt(k)) * N;
				return R;
			}


			float3 RefractFixed796(float3 V , float3 N , float Eta , float In0)
			{
				//float d = clamp(dot(N, V) + In0, -1, 0);
				float d = abs(dot(N, V) + In0) * -1;
				float k = 1.0 - Eta * Eta * (1.0 - d * d);
				float3 R = Eta * V - (Eta * d + sqrt(k)) * N;
				return R;
			}


			inline half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
			{
				return half4 (0, 0, 0, s.Alpha);
			}

			void surf(Input i , inout SurfaceOutput o)
			{
				o.Normal = float3(0,0,1);
				float temp_output_1023_0 = ((_Time.y * _StarsRotationSpeed) + _RotationStars);
				float3 ase_worldPos = i.worldPos;
				float3 ase_worldViewDir = normalize(UnityWorldSpaceViewDir(ase_worldPos));
				float3 rotatedValue646 = RotateAroundAxis(float3(0,0,0), -ase_worldViewDir, normalize(_RotationAxis), temp_output_1023_0);
				float3 V797 = rotatedValue646;
				float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
				float3 lerpResult929 = lerp(float3(0,0,1) , UnpackNormal(tex2D(_NormalTexture, uv_NormalTexture)) , _NormalAmount);
				float3 newWorldNormal402 = (WorldNormalVector(i , lerpResult929));
				float3 rotatedValue652 = RotateAroundAxis(float3(0,0,0), newWorldNormal402, normalize(_RotationAxis), temp_output_1023_0);
				float3 N797 = rotatedValue652;
				float3 ase_worldNormal = WorldNormalVector(i, float3(0, 0, 1));
				float fresnelNdotV642 = dot(ase_worldNormal, ase_worldViewDir);
				float fresnelNode642 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV642, _EtaFresnelExp));
				float clampResult799 = clamp(fresnelNode642 , 0.0 , 1.0);
				float clampResult881 = clamp((1.0 - pow((1.0 - clampResult799) , _EtaFresnelExp2)) , 0.0 , 1.0);
				float fresnelNdotV601 = dot(ase_worldNormal, ase_worldViewDir);
				float fresnelNode601 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV601, 1.0));
				float temp_output_190_0 = (_RimNoiseTwistAmount * fresnelNode601 * _RimNoiseTilingV);
				float3 appendResult997 = (float3(_RimNoiseSpherizePosition.x , _RimNoiseSpherizePosition.y , _RimNoiseSpherizePosition.z));
				float3 objToWorld606 = mul(unity_ObjectToWorld, float4(appendResult997, 1)).xyz;
				float3 normalizeResult499 = normalize((ase_worldPos - objToWorld606));
				float3 lerpResult602 = lerp(ase_worldNormal , normalizeResult499 , _RimNoiseSpherize);
				float3 worldToViewDir153 = mul(UNITY_MATRIX_V, float4(lerpResult602, 0)).xyz;
				float temp_output_173_0 = (0.0 + (atan2(worldToViewDir153.x , worldToViewDir153.y) - (-1.0 * UNITY_PI)) * (1.0 - 0.0) / (UNITY_PI - (-1.0 * UNITY_PI)));
				float temp_output_927_0 = (0.0 + (max((1.0 - temp_output_173_0) , temp_output_173_0) - 0.5) * (1.0 - 0.0) / (1.0 - 0.5));
				float temp_output_494_0 = (temp_output_927_0 * _RimNoiseTilingV);
				float temp_output_178_0 = ((fresnelNode601 * _RimNoiseTilingU) + (_Time.y * _RimNoiseScrollSpeed));
				float2 appendResult177 = (float2((temp_output_190_0 + temp_output_494_0) , temp_output_178_0));
				float3 worldToViewDir4 = mul(UNITY_MATRIX_V, float4(newWorldNormal402, 0)).xyz;
				float2 appendResult939 = (float2(_RimNoiseDistortionTilingU , _RimNoiseDistortionTilingV));
				float2 appendResult920 = (float2(temp_output_927_0 , temp_output_178_0));
				float fresnelNdotV948 = dot(newWorldNormal402, ase_worldViewDir);
				float fresnelNode948 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV948, 1.0));
				float3 temp_output_913_0 = (worldToViewDir4 * tex2D(_RimNoiseDistortionTexture, (appendResult939 * appendResult920)).r * _RimNoiseDistortionAmount * fresnelNode948);
				float3 lerpResult98 = lerp(newWorldNormal402 , ase_worldViewDir , (tex2D(_RimNoiseTexture, (float3(appendResult177 ,  0.0) + temp_output_913_0).xy).r * _RimNoiseAmount));
				float3 normalizeResult102 = normalize(lerpResult98);
				float fresnelNdotV17 = dot(normalizeResult102, ase_worldViewDir);
				float fresnelNode17 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV17, 1.0));
				float clampResult119 = clamp(pow(fresnelNode17 , _RimExp) , 0.0 , 1.0);
				float temp_output_78_0 = (1.0 - pow((1.0 - clampResult119) , _RimExp2));
				float temp_output_645_0 = (1.0 + (_Eta * clampResult881) + (temp_output_78_0 * -_RimNoiseRefraction));
				float Eta797 = temp_output_645_0;
				float In0797 = _EtaAAEdgesFix;
				float3 localRefractFixed797 = RefractFixed797(V797 , N797 , Eta797 , In0797);
				float4 texCUBENode640 = texCUBE(_StarsTexture, localRefractFixed797);
				float4 temp_cast_2 = (0.0).xxxx;
				float3 temp_cast_3 = (temp_output_78_0).xxx;
				float fresnelNdotV952 = dot(ase_worldNormal, ase_worldViewDir);
				float fresnelNode952 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV952, _RimNoiseCARimMaskExp));
				float temp_output_504_0 = (_RimNoiseCAU * _RimNoiseCAAmount * fresnelNode952);
				float temp_output_505_0 = (_RimNoiseCAAmount * _RimNoiseCAV * fresnelNode952);
				float temp_output_507_0 = (temp_output_178_0 + temp_output_505_0);
				float2 appendResult210 = (float2((temp_output_190_0 + temp_output_494_0 + temp_output_504_0) , temp_output_507_0));
				float3 lerpResult224 = lerp(newWorldNormal402 , ase_worldViewDir , (tex2D(_RimNoiseTexture, (float3(appendResult210 ,  0.0) + temp_output_913_0).xy).r * _RimNoiseAmount));
				float3 normalizeResult228 = normalize(lerpResult224);
				float fresnelNdotV230 = dot(normalizeResult228, ase_worldViewDir);
				float fresnelNode230 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV230, 1.0));
				float clampResult234 = clamp(pow(fresnelNode230 , _RimExp) , 0.0 , 1.0);
				float2 appendResult211 = (float2((temp_output_190_0 + temp_output_494_0 + (temp_output_504_0 * 2.0)) , (temp_output_507_0 + (temp_output_505_0 * 2.0))));
				float3 lerpResult227 = lerp(newWorldNormal402 , ase_worldViewDir , (tex2D(_RimNoiseTexture, (float3(appendResult211 ,  0.0) + temp_output_913_0).xy).r * _RimNoiseAmount));
				float3 normalizeResult229 = normalize(lerpResult227);
				float fresnelNdotV231 = dot(normalizeResult229, ase_worldViewDir);
				float fresnelNode231 = (0.0 + 1.0 * pow(1.0 - fresnelNdotV231, 1.0));
				float clampResult240 = clamp(pow(fresnelNode231 , _RimExp) , 0.0 , 1.0);
				float3 appendResult245 = (float3(temp_output_78_0 , (1.0 - pow((1.0 - clampResult234) , _RimExp2)) , (1.0 - pow((1.0 - clampResult240) , _RimExp2))));
				#ifdef _RIMNOISECAENABLED_ON
					float3 staticSwitch1013 = appendResult245;
				#else
					float3 staticSwitch1013 = temp_cast_3;
				#endif
				#ifdef _RIMENABLED_ON
					float4 staticSwitch1009 = (float4(staticSwitch1013 , 0.0) * _RimEmissionPower * _RimColor);
				#else
					float4 staticSwitch1009 = temp_cast_2;
				#endif
				float lerpResult841 = lerp(0.0 , 1.0 , _RimAddOrMultiply);
				float4 temp_output_846_0 = ((staticSwitch1009 * lerpResult841) + 1.0);
				float temp_output_1024_0 = ((_Time.y * _CloudsRotationSpeed) + _RotationClouds);
				float3 rotatedValue684 = RotateAroundAxis(float3(0,0,0), -ase_worldViewDir, normalize(_RotationAxis), temp_output_1024_0);
				float3 V795 = rotatedValue684;
				float3 rotatedValue685 = RotateAroundAxis(float3(0,0,0), newWorldNormal402, normalize(_RotationAxis), temp_output_1024_0);
				float3 N795 = rotatedValue685;
				float Eta795 = temp_output_645_0;
				float In0795 = _EtaAAEdgesFix;
				float3 localRefractFixed795 = RefractFixed795(V795 , N795 , Eta795 , In0795);
				float4 texCUBENode674 = texCUBE(_CloudsTexture, localRefractFixed795);
				float clampResult744 = clamp(pow(texCUBENode674.r , _CloudsRampOffsetExp) , 0.0 , 1.0);
				float2 appendResult720 = (float2((1.0 - pow((1.0 - clampResult744) , _CloudsRampOffsetExp2)) , 0.0));
				float4 tex2DNode719 = tex2D(_CloudsRamp, appendResult720);
				float clampResult733 = clamp((pow(texCUBENode674.r , _CloudsOpacityExp) * _CloudsOpacityPower) , 0.0 , 1.0); // This is our primary alpha source
				float4 lerpResult871 = lerp((texCUBENode640 * _StarsEmissionPower * temp_output_846_0) , (tex2DNode719 * _CloudsEmissionPower * _CloudsRampColorTint * temp_output_846_0) , clampResult733);
				float4 temp_cast_9 = (0.0).xxxx;
				float temp_output_1025_0 = ((_Time.y * _DarkCloudsRotationSpeed) + _RotationDarkClouds);
				float3 rotatedValue686 = RotateAroundAxis(float3(0,0,0), -ase_worldViewDir, normalize(_RotationAxis), temp_output_1025_0);
				float3 V796 = rotatedValue686;
				float3 rotatedValue687 = RotateAroundAxis(float3(0,0,0), newWorldNormal402, normalize(_RotationAxis), temp_output_1025_0);
				float3 N796 = rotatedValue687;
				float Eta796 = temp_output_645_0;
				float In0796 = _EtaAAEdgesFix;
				float3 localRefractFixed796 = RefractFixed796(V796 , N796 , Eta796 , In0796);
				float4 texCUBENode779 = texCUBE(_DarkCloudsTexture, localRefractFixed796);
				float clampResult787 = clamp(((pow(((_DarkCloudsEdgesGlowStyle) ? (texCUBENode779.b) : (texCUBENode779.g)) , _DarkCloudsEdgesGlowExp) * _DarkCloudsEdgesGlowPower) + 1.0) , 0.0 , _DarkCloudsEdgesGlowClamp);
				float4 lerpResult740 = lerp((texCUBENode640 * _StarsEmissionPower * clampResult787 * temp_output_846_0) , (tex2DNode719 * _CloudsEmissionPower * _CloudsRampColorTint * clampResult787 * temp_output_846_0) , clampResult733);
				float clampResult773 = clamp((pow(texCUBENode779.r , _DarkCloudsThicker) * _DarkCloudsLighten) , 0.0 , 1.0);
				float4 lerpResult745 = lerp(temp_cast_9 , lerpResult740 , clampResult773);
				#ifdef _DARKCLOUDSENABLED_ON
					float4 staticSwitch868 = lerpResult745;
				#else
					float4 staticSwitch868 = lerpResult871;
				#endif
				o.Emission = ((_FinalPower * staticSwitch868) + (staticSwitch1009 * (1.0 - lerpResult841))).rgb;

				// MODIFIED Alpha output
				// Use the cloud opacity, potentially modulated by dark cloud opacity if enabled, and then by global alpha
				float calculatedAlpha = clampResult733;
				#ifdef _DARKCLOUDSENABLED_ON
				// If dark clouds are a separate layer, you might want to blend alphas.
				// For simplicity, let's assume dark clouds opacity (clampResult773) affects the color lerp, 
				// and the main cloud opacity (clampResult733) still drives the overall transparency.
				// Or, if dark clouds are supposed to be more solid when visible:
				// calculatedAlpha = lerp(clampResult733, 1.0, clampResult773); // Example: dark clouds become more opaque
			#endif
			o.Alpha = calculatedAlpha * _GlobalAlpha;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On // Shadow caster should write to depth
			// Cull Back // Default cull is fine here
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				Input customInputData;
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}
			half4 frag(v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT(Input, surfIN);
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z);
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT(SurfaceOutput, o)
				surf(surfIN, o);

				// For shadow casting with transparency, you often use alpha testing (discarding pixels below a threshold)
				// If you want shadows to be based on the alpha:
				// clip(o.Alpha - _Cutoff); // You'd need to define _Cutoff property
				// For simple transparency where it might not cast strong shadows or no shadows,
				// this setup might be okay, or you could remove the ShadowCaster pass entirely
				// if this object should not cast shadows.

				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT(IN)
			}
			ENDCG
		}
		}
			Fallback "Diffuse"
					CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18200
... (Your ASE graph data remains the same) ...
ASEEND*/
//CHKSM...