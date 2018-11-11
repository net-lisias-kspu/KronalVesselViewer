// Compiled shader for PC, Mac & Linux Standalone, uncompressed size: 4.7KB

Shader "KVV/Color Adjust" {
	SubShader{


		// Stats for Vertex shader:
		//       d3d11 : 4 math
		//    d3d11_9x : 4 math
		//        d3d9 : 7 math
		// Stats for Fragment shader:
		//        d3d9 : 1 math
		Pass{
		ZTest Always
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		GpuProgramID 59973
		Program "vp" {
		SubProgram "d3d9 " {
			// Stats: 7 math
			Bind "vertex" Vertex
				Bind "color" Color
				Matrix 0[glstate_matrix_mvp]
				"vs_2_0
				def c4, 0, 1, 0, 0
				dcl_position v0
				dcl_color v1
				max r0, v1, c4.x
				min oD0, r0, c4.y
				mad r0, v0.xyzx, c4.yyyx, c4.xxxy
				dp4 oPos.x, c0, r0
				dp4 oPos.y, c1, r0
				dp4 oPos.z, c2, r0
				dp4 oPos.w, c3, r0

				"
		}
		SubProgram "d3d11 " {
			// Stats: 4 math
			Bind "vertex" Vertex
				Bind "color" Color
				ConstBuffer "UnityPerDraw" 352
				Matrix 0[glstate_matrix_mvp]
				BindCB  "UnityPerDraw" 0
				"vs_4_0
				root12:aaabaaaa
				eefiecednnokfampbpcfihidfeohlcgdkabejapiabaaaaaaneabaaaaadaaaaaa
				cmaaaaaahmaaaaaanaaaaaaaejfdeheoeiaaaaaaacaaaaaaaiaaaaaadiaaaaaa
				aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaahahaaaaebaaaaaaaaaaaaaaaaaaaaaa
				adaaaaaaabaaaaaaapapaaaafaepfdejfeejepeoaaedepemepfcaaklepfdeheo
				emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
				apaaaaaadoaaaaaaaaaaaaaaabaaaaaaadaaaaaaabaaaaaaapaaaaaaedepemep
				fcaafdfgfpfaepfdejfeejepeoaaklklfdeieefcpmaaaaaaeaaaabaadpaaaaaa
				fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
				pcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaaghaaaaaepccabaaaabaaaaaa
				abaaaaaagiaaaaacabaaaaaadgcaaaafpccabaaaaaaaaaaaegbobaaaabaaaaaa
				diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
				dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
				egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
				kgbkbaaaaaaaaaaaegaobaaaaaaaaaaaaaaaaaaipccabaaaabaaaaaaegaobaaa
				aaaaaaaaegiocaaaaaaaaaaaadaaaaaadoaaaaab"
		}
		SubProgram "d3d11_9x " {
			// Stats: 4 math
			Bind "vertex" Vertex
				Bind "color" Color
				ConstBuffer "UnityPerDraw" 352
				Matrix 0[glstate_matrix_mvp]
				BindCB  "UnityPerDraw" 0
				"vs_4_0_level_9_1
				root12:aaabaaaa
				eefiecedcfghaehiflkiadammnbhgoeffaafiaogabaaaaaaneacaaaaaeaaaaaa
				daaaaaaacmabaaaadaacaaaaiaacaaaaebgpgodjpeaaaaaapeaaaaaaaaacpopp
				maaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
				aeaaabaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafafaaapkaaaaaaaaaaaaaiadp
				aaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
				alaaaaadaaaaapiaabaaoejaafaaaakaakaaaaadaaaaapoaaaaaoeiaafaaffka
				afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
				aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaacaaaaadaaaaapia
				aaaaoeiaaeaaoekaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
				aaaaammaaaaaoeiappppaaaafdeieefcpmaaaaaaeaaaabaadpaaaaaafjaaaaae
				egiocaaaaaaaaaaaaeaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaa
				abaaaaaagfaaaaadpccabaaaaaaaaaaaghaaaaaepccabaaaabaaaaaaabaaaaaa
				giaaaaacabaaaaaadgcaaaafpccabaaaaaaaaaaaegbobaaaabaaaaaadiaaaaai
				pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
				pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
				aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
				aaaaaaaaegaobaaaaaaaaaaaaaaaaaaipccabaaaabaaaaaaegaobaaaaaaaaaaa
				egiocaaaaaaaaaaaadaaaaaadoaaaaabejfdeheoeiaaaaaaacaaaaaaaiaaaaaa
				diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaahahaaaaebaaaaaaaaaaaaaa
				aaaaaaaaadaaaaaaabaaaaaaapapaaaafaepfdejfeejepeoaaedepemepfcaakl
				epfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
				aaaaaaaaapaaaaaadoaaaaaaaaaaaaaaabaaaaaaadaaaaaaabaaaaaaapaaaaaa
				edepemepfcaafdfgfpfaepfdejfeejepeoaaklkl"
		}
	}
	Program "fp" {
		SubProgram "d3d9 " {
			// Stats: 1 math
			"ps_2_0
				dcl v0
				mov_pp oC0, v0

				"
		}
		SubProgram "d3d11 " {
			"ps_4_0
				root12:aaaaaaaa
				eefiecedeonnbajhhfbahmkfdfkaicoeamjejkmjabaaaaaapeaaaaaaadaaaaaa
				cmaaaaaaiaaaaaaaleaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
				aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaadoaaaaaaaaaaaaaaabaaaaaa
				adaaaaaaabaaaaaaapaaaaaaedepemepfcaafdfgfpfaepfdejfeejepeoaaklkl
				epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
				aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiaaaaaaeaaaaaaa
				aoaaaaaagcbaaaadpcbabaaaaaaaaaaagfaaaaadpccabaaaaaaaaaaadgaaaaaf
				pccabaaaaaaaaaaaegbobaaaaaaaaaaadoaaaaab"
		}
		SubProgram "d3d11_9x " {
			"ps_4_0_level_9_1
				root12:aaaaaaaa
				eefiecedefmlfipfgbcblgegmcbhfjgbphlcgehmabaaaaaaeeabaaaaaeaaaaaa
				daaaaaaahmaaaaaalmaaaaaabaabaaaaebgpgodjeeaaaaaaeeaaaaaaaaacpppp
				caaaaaaaceaaaaaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaacpppp
				bpaaaaacaaaaaaiaaaaacplaabaaaaacaaaicpiaaaaaoelappppaaaafdeieefc
				diaaaaaaeaaaaaaaaoaaaaaagcbaaaadpcbabaaaaaaaaaaagfaaaaadpccabaaa
				aaaaaaaadgaaaaafpccabaaaaaaaaaaaegbobaaaaaaaaaaadoaaaaabejfdeheo
				emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
				apapaaaadoaaaaaaaaaaaaaaabaaaaaaadaaaaaaabaaaaaaapaaaaaaedepemep
				fcaafdfgfpfaepfdejfeejepeoaaklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
				caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
				heaaklkl"
		}
	}
	}
	}
}