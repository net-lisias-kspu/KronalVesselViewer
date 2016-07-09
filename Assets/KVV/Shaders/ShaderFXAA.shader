Shader "KVV/Hidden/SlinDev/Desktop/PostProcessing/FXAA"
{
    Properties
    {
        _MainTex ("Base (RGB)", RECT) = "white" {}
    }

    SubShader
    {
        Pass
        {
            ZTest Always
            Cull Off
            ZWrite Off
            Fog { Mode off }
    
            Program "vp" {
// Vertex combos: 1
//   d3d9 - ALU: 7 to 7
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD0;
uniform vec4 _MainTex_TexelSize;

void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xy = gl_MultiTexCoord0.xy;
  tmpvar_1.zw = (gl_MultiTexCoord0.xy - (_MainTex_TexelSize.xy * 0.75));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD0;
uniform vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
void main ()
{
  vec4 tmpvar_1;
  vec2 dir_2;
  vec2 tmpvar_3;
  tmpvar_3.y = 0.0;
  tmpvar_3.x = _MainTex_TexelSize.x;
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = (xlv_TEXCOORD0.zw + tmpvar_3);
  vec2 tmpvar_5;
  tmpvar_5.x = 0.0;
  tmpvar_5.y = _MainTex_TexelSize.y;
  vec4 tmpvar_6;
  tmpvar_6.zw = vec2(0.0, 0.0);
  tmpvar_6.xy = (xlv_TEXCOORD0.zw + tmpvar_5);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = (xlv_TEXCOORD0.zw + _MainTex_TexelSize.xy);
  float tmpvar_8;
  tmpvar_8 = dot (texture2DLod (_MainTex, xlv_TEXCOORD0.zw, 0.0).xyz, vec3(0.299, 0.587, 0.114));
  float tmpvar_9;
  tmpvar_9 = dot (texture2DLod (_MainTex, tmpvar_4.xy, 0.0).xyz, vec3(0.299, 0.587, 0.114));
  float tmpvar_10;
  tmpvar_10 = dot (texture2DLod (_MainTex, tmpvar_6.xy, 0.0).xyz, vec3(0.299, 0.587, 0.114));
  float tmpvar_11;
  tmpvar_11 = dot (texture2DLod (_MainTex, tmpvar_7.xy, 0.0).xyz, vec3(0.299, 0.587, 0.114));
  float tmpvar_12;
  tmpvar_12 = dot (texture2DLod (_MainTex, xlv_TEXCOORD0.xy, 0.0).xyz, vec3(0.299, 0.587, 0.114));
  float tmpvar_13;
  tmpvar_13 = min (tmpvar_12, min (min (tmpvar_8, tmpvar_9), min (tmpvar_10, tmpvar_11)));
  float tmpvar_14;
  tmpvar_14 = max (tmpvar_12, max (max (tmpvar_8, tmpvar_9), max (tmpvar_10, tmpvar_11)));
  dir_2.x = ((tmpvar_10 + tmpvar_11) - (tmpvar_8 + tmpvar_9));
  dir_2.y = ((tmpvar_8 + tmpvar_10) - (tmpvar_9 + tmpvar_11));
  vec2 tmpvar_15;
  tmpvar_15 = (min (vec2(8.0, 8.0), max (vec2(-8.0, -8.0), (dir_2 * (1.0/((min (abs(dir_2.x), abs(dir_2.y)) + max (((((tmpvar_8 + tmpvar_9) + tmpvar_10) + tmpvar_11) * 0.03125), 0.0078125))))))) * _MainTex_TexelSize.xy);
  dir_2 = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = (xlv_TEXCOORD0.xy + (tmpvar_15 * -0.166667));
  vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, 0.0);
  tmpvar_17.xy = (xlv_TEXCOORD0.xy + (tmpvar_15 * 0.166667));
  vec3 tmpvar_18;
  tmpvar_18 = (0.5 * (texture2DLod (_MainTex, tmpvar_16.xy, 0.0).xyz + texture2DLod (_MainTex, tmpvar_17.xy, 0.0).xyz));
  vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, 0.0);
  tmpvar_19.xy = (xlv_TEXCOORD0.xy + (tmpvar_15 * -0.5));
  vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, 0.0);
  tmpvar_20.xy = (xlv_TEXCOORD0.xy + (tmpvar_15 * 0.5));
  vec3 tmpvar_21;
  tmpvar_21 = ((tmpvar_18 * 0.5) + (0.25 * (texture2DLod (_MainTex, tmpvar_19.xy, 0.0).xyz + texture2DLod (_MainTex, tmpvar_20.xy, 0.0).xyz)));
  float tmpvar_22;
  tmpvar_22 = dot (tmpvar_21, vec3(0.299, 0.587, 0.114));
  if (((tmpvar_22 < tmpvar_13) || (tmpvar_22 > tmpvar_14))) {
    vec4 tmpvar_23;
    tmpvar_23.w = 1.0;
    tmpvar_23.xyz = tmpvar_18;
    tmpvar_1 = tmpvar_23;
  } else {
    vec4 tmpvar_24;
    tmpvar_24.w = 1.0;
    tmpvar_24.xyz = tmpvar_21;
    tmpvar_1 = tmpvar_24;
  };
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 7 ALU
dcl_position o0
dcl_texcoord0 o1
def c5, 0.75000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mad o1.zw, c5.x, -r0.xyxy, v1.xyxy
mov o1.xy, v1
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 32 // 32 used size, 2 vars
Vector 16 [_MainTex_TexelSize] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedomhnakjjegdgnhbeoddhigjpdalhheicabaaaaaacmacaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcemabaaaa
eaaaabaafdaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaao
mccabaaaabaaaaaaagiecaiaebaaaaaaaaaaaaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaeadpaaaaeadpagbebaaaabaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  tmpvar_1.xy = tmpvar_2;
  tmpvar_1.zw = (tmpvar_1.xy - (_MainTex_TexelSize.xy * 0.75));
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 rgbA_2;
  highp vec2 dir_3;
  highp vec3 rgbM_4;
  highp vec3 rgbSE_5;
  highp vec3 rgbSW_6;
  highp vec3 rgbNE_7;
  highp vec3 rgbNW_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = texture2DLodEXT (_MainTex, xlv_TEXCOORD0.zw, 0.0).xyz;
  rgbNW_8 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.y = 0.0;
  tmpvar_10.x = _MainTex_TexelSize.x;
  highp vec4 tmpvar_11;
  tmpvar_11.zw = vec2(0.0, 0.0);
  tmpvar_11.xy = (xlv_TEXCOORD0.zw + tmpvar_10);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2DLodEXT (_MainTex, tmpvar_11.xy, 0.0).xyz;
  rgbNE_7 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = _MainTex_TexelSize.y;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, 0.0);
  tmpvar_14.xy = (xlv_TEXCOORD0.zw + tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2DLodEXT (_MainTex, tmpvar_14.xy, 0.0).xyz;
  rgbSW_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = (xlv_TEXCOORD0.zw + _MainTex_TexelSize.xy);
  lowp vec3 tmpvar_17;
  tmpvar_17 = texture2DLodEXT (_MainTex, tmpvar_16.xy, 0.0).xyz;
  rgbSE_5 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2DLodEXT (_MainTex, xlv_TEXCOORD0.xy, 0.0).xyz;
  rgbM_4 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (rgbNW_8, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_20;
  tmpvar_20 = dot (rgbNE_7, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_21;
  tmpvar_21 = dot (rgbSW_6, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_22;
  tmpvar_22 = dot (rgbSE_5, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_23;
  tmpvar_23 = dot (rgbM_4, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_24;
  tmpvar_24 = min (tmpvar_23, min (min (tmpvar_19, tmpvar_20), min (tmpvar_21, tmpvar_22)));
  highp float tmpvar_25;
  tmpvar_25 = max (tmpvar_23, max (max (tmpvar_19, tmpvar_20), max (tmpvar_21, tmpvar_22)));
  dir_3.x = ((tmpvar_21 + tmpvar_22) - (tmpvar_19 + tmpvar_20));
  dir_3.y = ((tmpvar_19 + tmpvar_21) - (tmpvar_20 + tmpvar_22));
  highp vec2 tmpvar_26;
  tmpvar_26 = (min (vec2(8.0, 8.0), max (vec2(-8.0, -8.0), (dir_3 * (1.0/((min (abs(dir_3.x), abs(dir_3.y)) + max (((((tmpvar_19 + tmpvar_20) + tmpvar_21) + tmpvar_22) * 0.03125), 0.0078125))))))) * _MainTex_TexelSize.xy);
  dir_3 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27.zw = vec2(0.0, 0.0);
  tmpvar_27.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * -0.166667));
  highp vec4 tmpvar_28;
  tmpvar_28.zw = vec2(0.0, 0.0);
  tmpvar_28.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * 0.166667));
  lowp vec3 tmpvar_29;
  tmpvar_29 = (0.5 * (texture2DLodEXT (_MainTex, tmpvar_27.xy, 0.0).xyz + texture2DLodEXT (_MainTex, tmpvar_28.xy, 0.0).xyz));
  rgbA_2 = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.zw = vec2(0.0, 0.0);
  tmpvar_30.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * -0.5));
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2DLodEXT (_MainTex, tmpvar_30.xy, 0.0);
  highp vec4 tmpvar_32;
  tmpvar_32.zw = vec2(0.0, 0.0);
  tmpvar_32.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * 0.5));
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2DLodEXT (_MainTex, tmpvar_32.xy, 0.0);
  highp vec3 tmpvar_34;
  tmpvar_34 = ((rgbA_2 * 0.5) + (0.25 * (tmpvar_31.xyz + tmpvar_33.xyz)));
  highp float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec3(0.299, 0.587, 0.114));
  if (((tmpvar_35 < tmpvar_24) || (tmpvar_35 > tmpvar_25))) {
    highp vec4 tmpvar_36;
    tmpvar_36.w = 1.0;
    tmpvar_36.xyz = rgbA_2;
    tmpvar_1 = tmpvar_36;
  } else {
    highp vec4 tmpvar_37;
    tmpvar_37.w = 1.0;
    tmpvar_37.xyz = tmpvar_34;
    tmpvar_1 = tmpvar_37;
  };
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  tmpvar_1.xy = tmpvar_2;
  tmpvar_1.zw = (tmpvar_1.xy - (_MainTex_TexelSize.xy * 0.75));
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 rgbA_2;
  highp vec2 dir_3;
  highp vec3 rgbM_4;
  highp vec3 rgbSE_5;
  highp vec3 rgbSW_6;
  highp vec3 rgbNE_7;
  highp vec3 rgbNW_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = texture2DLodEXT (_MainTex, xlv_TEXCOORD0.zw, 0.0).xyz;
  rgbNW_8 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.y = 0.0;
  tmpvar_10.x = _MainTex_TexelSize.x;
  highp vec4 tmpvar_11;
  tmpvar_11.zw = vec2(0.0, 0.0);
  tmpvar_11.xy = (xlv_TEXCOORD0.zw + tmpvar_10);
  lowp vec3 tmpvar_12;
  tmpvar_12 = texture2DLodEXT (_MainTex, tmpvar_11.xy, 0.0).xyz;
  rgbNE_7 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = _MainTex_TexelSize.y;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, 0.0);
  tmpvar_14.xy = (xlv_TEXCOORD0.zw + tmpvar_13);
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2DLodEXT (_MainTex, tmpvar_14.xy, 0.0).xyz;
  rgbSW_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = (xlv_TEXCOORD0.zw + _MainTex_TexelSize.xy);
  lowp vec3 tmpvar_17;
  tmpvar_17 = texture2DLodEXT (_MainTex, tmpvar_16.xy, 0.0).xyz;
  rgbSE_5 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2DLodEXT (_MainTex, xlv_TEXCOORD0.xy, 0.0).xyz;
  rgbM_4 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (rgbNW_8, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_20;
  tmpvar_20 = dot (rgbNE_7, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_21;
  tmpvar_21 = dot (rgbSW_6, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_22;
  tmpvar_22 = dot (rgbSE_5, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_23;
  tmpvar_23 = dot (rgbM_4, vec3(0.299, 0.587, 0.114));
  highp float tmpvar_24;
  tmpvar_24 = min (tmpvar_23, min (min (tmpvar_19, tmpvar_20), min (tmpvar_21, tmpvar_22)));
  highp float tmpvar_25;
  tmpvar_25 = max (tmpvar_23, max (max (tmpvar_19, tmpvar_20), max (tmpvar_21, tmpvar_22)));
  dir_3.x = ((tmpvar_21 + tmpvar_22) - (tmpvar_19 + tmpvar_20));
  dir_3.y = ((tmpvar_19 + tmpvar_21) - (tmpvar_20 + tmpvar_22));
  highp vec2 tmpvar_26;
  tmpvar_26 = (min (vec2(8.0, 8.0), max (vec2(-8.0, -8.0), (dir_3 * (1.0/((min (abs(dir_3.x), abs(dir_3.y)) + max (((((tmpvar_19 + tmpvar_20) + tmpvar_21) + tmpvar_22) * 0.03125), 0.0078125))))))) * _MainTex_TexelSize.xy);
  dir_3 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27.zw = vec2(0.0, 0.0);
  tmpvar_27.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * -0.166667));
  highp vec4 tmpvar_28;
  tmpvar_28.zw = vec2(0.0, 0.0);
  tmpvar_28.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * 0.166667));
  lowp vec3 tmpvar_29;
  tmpvar_29 = (0.5 * (texture2DLodEXT (_MainTex, tmpvar_27.xy, 0.0).xyz + texture2DLodEXT (_MainTex, tmpvar_28.xy, 0.0).xyz));
  rgbA_2 = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.zw = vec2(0.0, 0.0);
  tmpvar_30.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * -0.5));
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2DLodEXT (_MainTex, tmpvar_30.xy, 0.0);
  highp vec4 tmpvar_32;
  tmpvar_32.zw = vec2(0.0, 0.0);
  tmpvar_32.xy = (xlv_TEXCOORD0.xy + (tmpvar_26 * 0.5));
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2DLodEXT (_MainTex, tmpvar_32.xy, 0.0);
  highp vec3 tmpvar_34;
  tmpvar_34 = ((rgbA_2 * 0.5) + (0.25 * (tmpvar_31.xyz + tmpvar_33.xyz)));
  highp float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec3(0.299, 0.587, 0.114));
  if (((tmpvar_35 < tmpvar_24) || (tmpvar_35 > tmpvar_25))) {
    highp vec4 tmpvar_36;
    tmpvar_36.w = 1.0;
    tmpvar_36.xyz = rgbA_2;
    tmpvar_1 = tmpvar_36;
  } else {
    highp vec4 tmpvar_37;
    tmpvar_37.w = 1.0;
    tmpvar_37.xyz = tmpvar_34;
    tmpvar_1 = tmpvar_37;
  };
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;

#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 308
struct v2f {
    highp vec4 pos;
    highp vec4 posPos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_TexelSize;
#line 314
#line 322
#line 314
v2f vert( in appdata_img v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 318
    o.posPos.xy = v.texcoord.xy;
    o.posPos.zw = (o.posPos.xy - (_MainTex_TexelSize.xy * 0.75));
    return o;
}
out highp vec4 xlv_TEXCOORD0;
void main() {
    v2f xl_retval;
    appdata_img xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.texcoord = vec2(gl_MultiTexCoord0);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.posPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
vec4 xll_tex2Dlod(sampler2D s, vec4 coord) {
   return textureLod( s, coord.xy, coord.w);
}
#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 308
struct v2f {
    highp vec4 pos;
    highp vec4 posPos;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform sampler2D _MainTex;
uniform highp vec4 _MainTex_TexelSize;
#line 314
#line 322
#line 322
highp vec4 frag( in v2f i ) {
    highp vec3 rgbNW = xll_tex2Dlod( _MainTex, vec4( i.posPos.zw, 0.0, 0.0)).xyz;
    highp vec3 rgbNE = xll_tex2Dlod( _MainTex, vec4( (i.posPos.zw + vec2( _MainTex_TexelSize.x, 0.0)), 0.0, 0.0)).xyz;
    #line 326
    highp vec3 rgbSW = xll_tex2Dlod( _MainTex, vec4( (i.posPos.zw + vec2( 0.0, _MainTex_TexelSize.y)), 0.0, 0.0)).xyz;
    highp vec3 rgbSE = xll_tex2Dlod( _MainTex, vec4( (i.posPos.zw + _MainTex_TexelSize.xy), 0.0, 0.0)).xyz;
    highp vec3 rgbM = xll_tex2Dlod( _MainTex, vec4( i.posPos.xy, 0.0, 0.0)).xyz;
    highp vec3 luma = vec3( 0.299, 0.587, 0.114);
    #line 330
    highp float lumaNW = dot( rgbNW, luma);
    highp float lumaNE = dot( rgbNE, luma);
    highp float lumaSW = dot( rgbSW, luma);
    highp float lumaSE = dot( rgbSE, luma);
    #line 334
    highp float lumaM = dot( rgbM, luma);
    highp float lumaMin = min( lumaM, min( min( lumaNW, lumaNE), min( lumaSW, lumaSE)));
    highp float lumaMax = max( lumaM, max( max( lumaNW, lumaNE), max( lumaSW, lumaSE)));
    highp vec2 dir;
    #line 338
    dir.x = (-((lumaNW + lumaNE) - (lumaSW + lumaSE)));
    dir.y = ((lumaNW + lumaSW) - (lumaNE + lumaSE));
    highp float dirReduce = max( ((((lumaNW + lumaNE) + lumaSW) + lumaSE) * 0.03125), 0.0078125);
    highp float rcpDirMin = (1.0 / (min( abs(dir.x), abs(dir.y)) + dirReduce));
    #line 342
    dir = (min( vec2( 8.0, 8.0), max( vec2( -8.0, -8.0), (dir * rcpDirMin))) * _MainTex_TexelSize.xy);
    highp vec3 rgbA = (0.5 * (xll_tex2Dlod( _MainTex, vec4( (i.posPos.xy + (dir * -0.166667)), 0.0, 0.0)).xyz + xll_tex2Dlod( _MainTex, vec4( (i.posPos.xy + (dir * 0.166667)), 0.0, 0.0)).xyz));
    highp vec3 rgbB = ((rgbA * 0.5) + (0.25 * (xll_tex2Dlod( _MainTex, vec4( (i.posPos.xy + (dir * -0.5)), 0.0, 0.0)).xyz + xll_tex2Dlod( _MainTex, vec4( (i.posPos.xy + (dir * 0.5)), 0.0, 0.0)).xyz)));
    highp float lumaB = dot( rgbB, luma);
    #line 346
    if (((lumaB < lumaMin) || (lumaB > lumaMax))){
        return vec4( rgbA, 1.0);
    }
    return vec4( rgbB, 1.0);
}
in highp vec4 xlv_TEXCOORD0;
void main() {
    highp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posPos = vec4(xlv_TEXCOORD0);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   d3d9 - ALU: 71 to 71, TEX: 18 to 18
//   d3d11 - ALU: 37 to 37, TEX: 0 to 0, FLOW: 3 to 3
SubProgram "opengl " {
Keywords { }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 71 ALU, 18 TEX
dcl_2d s0
def c1, 0.29899999, 0.58700001, 0.11400000, 0.00000000
def c2, 0.03125000, 0.00781250, -8.00000000, 8.00000000
def c3, -0.16666666, 0.16666669, 0.50000000, -0.50000000
def c4, 0.25000000, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
add r0.xy, v0.zwzw, c0
mov r0.z, c1.w
texldl r2.xyz, r0.xyzz, s0
dp3 r4.x, r2, c1
mov r0.z, c1.w
mov r0.y, c0
mov r0.x, c1.w
add r0.xy, v0.zwzw, r0
texldl r0.xyz, r0.xyzz, s0
dp3 r2.w, r0, c1
add r3.x, r2.w, r4
mov r0.z, c1.w
mov r0.y, c1.w
mov r0.x, c0
add r0.xy, v0.zwzw, r0
texldl r2.xyz, r0.xyzz, s0
dp3 r3.w, r2, c1
mov r2.z, c1.w
mov r0.z, c1.w
mov r0.xy, v0.zwzw
texldl r0.xyz, r0.xyzz, s0
dp3 r0.w, r0, c1
add r0.y, r0.w, r3.w
add r0.x, r0.y, -r3
add r0.y, r2.w, r0
add r2.y, r4.x, r0
abs r2.x, -r0
mul r2.y, r2, c2.x
add r0.y, r0.w, r2.w
add r0.z, r3.w, r4.x
add r0.y, r0, -r0.z
abs r0.z, r0.y
max r2.y, r2, c2
min r0.z, r2.x, r0
add r0.z, r0, r2.y
rcp r0.z, r0.z
mov r0.x, -r0
mul r0.xy, r0, r0.z
max r0.xy, r0, c2.z
min r0.xy, r0, c2.w
mul r0.xy, r0, c0
mad r2.xy, r0, c3.z, v0
texldl r3.xyz, r2.xyzz, s0
mad r2.xy, r0, c3.w, v0
mov r2.z, c1.w
texldl r2.xyz, r2.xyzz, s0
add r3.xyz, r2, r3
mad r2.xy, r0, c3.y, v0
mov r2.z, c1.w
mul r3.xyz, r3, c4.x
texldl r2.xyz, r2.xyzz, s0
mov r0.z, c1.w
mad r0.xy, r0, c3.x, v0
texldl r0.xyz, r0.xyzz, s0
add r0.xyz, r0, r2
mul r2.xyz, r0, c3.z
mad r0.xyz, r2, c3.z, r3
min r3.y, r2.w, r4.x
min r3.x, r0.w, r3.w
min r4.z, r3.x, r3.y
dp3 r4.y, r0, c1
max r0.w, r0, r3
max r2.w, r2, r4.x
max r2.w, r0, r2
mov r3.z, c1.w
mov r3.xy, v0
texldl r3.xyz, r3.xyzz, s0
dp3 r0.w, r3, c1
max r2.w, r0, r2
min r0.w, r0, r4.z
add r2.w, -r4.y, r2
add r0.w, r4.y, -r0
cmp r2.w, r2, c4.y, c4.z
cmp r0.w, r0, c4.y, c4.z
add_pp_sat r3.x, r0.w, r2.w
mov r2.w, c4.z
cmp_pp r3.y, -r3.x, c4.z, c4
mov r0.w, c4.z
cmp r1, -r3.x, r1, r2
cmp oC0, -r3.y, r1, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 32 // 32 used size, 2 vars
Vector 16 [_MainTex_TexelSize] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 58 instructions, 5 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 1 uint
// TEX 0 (9 load, 0 comp, 0 bias, 0 grad)
// FLOW 2 static, 1 dynamic
"ps_4_0
eefiecedkfbajehpmbecbfidhdaepggfbcfghigoabaaaaaagaaiaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckaahaaaa
eaaaaaaaoiabaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaeiaaaaalpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaa
dgaaaaagjcaabaaaabaaaaaaagiecaaaaaaaaaaaabaaaaaadgaaaaaigcaabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaogbobaaaabaaaaaaeiaaaaalpcaabaaaacaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaa
eiaaaaalpcaabaaaabaaaaaaogakbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaabeaaaaaaaaaaaaaaaaaaaaidcaabaaaadaaaaaaogbkbaaaabaaaaaa
egiacaaaaaaaaaaaabaaaaaaeiaaaaalpcaabaaaadaaaaaaegaabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaaeiaaaaalpcaabaaa
aeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaihbgjjdo
kcefbgdpnfhiojdnaaaaaaaabaaaaaakccaabaaaaaaaaaaaegacbaaaacaaaaaa
aceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaabaaaaaakecaabaaaaaaaaaaa
egacbaaaabaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdnaaaaaaaabaaaaaak
icaabaaaaaaaaaaaegacbaaaadaaaaaaaceaaaaaihbgjjdokcefbgdpnfhiojdn
aaaaaaaabaaaaaakbcaabaaaabaaaaaaegacbaaaaeaaaaaaaceaaaaaihbgjjdo
kcefbgdpnfhiojdnaaaaaaaaddaaaaahgcaabaaaabaaaaaafgahbaaaaaaaaaaa
agacbaaaaaaaaaaaddaaaaahccaabaaaabaaaaaackaabaaaabaaaaaabkaabaaa
abaaaaaaddaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaa
deaaaaahmcaabaaaabaaaaaafganbaaaaaaaaaaaagaibaaaaaaaaaaadeaaaaah
ecaabaaaabaaaaaadkaabaaaabaaaaaackaabaaaabaaaaaadeaaaaahbcaabaaa
abaaaaaackaabaaaabaaaaaaakaabaaaabaaaaaaaaaaaaahmcaabaaaabaaaaaa
fganbaaaaaaaaaaaagaibaaaaaaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaackaabaaaabaaaaaadgaaaaagfcaabaaaacaaaaaapgapbaia
ebaaaaaaabaaaaaaaaaaaaahdcaabaaaaaaaaaaaogakbaaaaaaaaaaaegaabaaa
aaaaaaaaaaaaaaaikcaabaaaacaaaaaafgafbaiaebaaaaaaaaaaaaaaagaabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaackaabaaaaaaaaaaackaabaaaabaaaaaa
aaaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadndeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadmddaaaaajccaabaaaaaaaaaaa
dkaabaiaibaaaaaaabaaaaaadkaabaiaibaaaaaaacaaaaaaaaaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaaoaaaaakbcaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaadiaaaaah
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaadeaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaambaaaaaambaaaaaambaaaaaamb
ddaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaebaaaaaaeb
aaaaaaebaaaaaaebdiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiecaaa
aaaaaaaaabaaaaaadcaaaaampcaabaaaacaaaaaaogaobaaaaaaaaaaaaceaaaaa
klkkckloklkkckloklkkckdoklkkckdoegbebaaaabaaaaaaeiaaaaalpcaabaaa
adaaaaaaegaabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaabeaaaaa
aaaaaaaaeiaaaaalpcaabaaaacaaaaaaogakbaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaadcaaaaampcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaalpaaaaaalpaaaaaadpaaaaaadpegbebaaaabaaaaaaeiaaaaal
pcaabaaaadaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
abeaaaaaaaaaaaaaeiaaaaalpcaabaaaaaaaaaaaogakbaaaaaaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaaaaa
egacbaaaaaaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
ihbgjjdokcefbgdpnfhiojdnaaaaaaaadbaaaaahccaabaaaabaaaaaadkaabaaa
aaaaaaaabkaabaaaabaaaaaadbaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaa
dkaabaaaaaaaaaaadmaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaabkaabaaa
abaaaaaabpaaaeaddkaabaaaaaaaaaaadiaaaaakhccabaaaaaaaaaaaegacbaaa
acaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaabbfaaaaabdgaaaaafhccabaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 114

        }
    }
    
    Fallback off
}