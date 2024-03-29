RSRC                     VisualShader            ��������                                            M      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    script    op_type 	   function    input_name    parameter_name 
   qualifier    color_default    texture_filter    texture_repeat    texture_source    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    
   Texture2D     res://Sprites/Tiles/Boards1.png >��a�9[
   Texture2D     res://Sprites/Tiles/Boards8.png ��;|V	   &   local://VisualShaderNodeTexture_6th8x &
      &   local://VisualShaderNodeTexture_pexjj �
      !   local://VisualShaderNodeIf_7xapm �
      *   local://VisualShaderNodeMultiplyAdd_ohdp8 �
      %   local://VisualShaderNodeUVFunc_xh1c2 �      $   local://VisualShaderNodeInput_ki0f5 �      1   local://VisualShaderNodeTexture2DParameter_n3538       1   local://VisualShaderNodeTexture2DParameter_k6s66 a         local://VisualShader_c6cha �         VisualShaderNodeTexture                                                             VisualShaderNodeTexture                                  VisualShaderNodeIf             VisualShaderNodeMultiplyAdd                                                        �?  �?  �?                     	                  VisualShaderNodeUVFunc                   
   ��L���L�      
                    VisualShaderNodeInput             time       #   VisualShaderNodeTexture2DParameter             BGText       #   VisualShaderNodeTexture2DParameter          	   MainText                   VisualShader          �  shader_type spatial;
uniform sampler2D MainText : filter_nearest;
uniform sampler2D BGText;



void fragment() {
	vec4 n_out2p0;
// Texture2D:2
	n_out2p0 = texture(MainText, UV);
	float n_out2p4 = n_out2p0.a;


// Input:7
	float n_out7p0 = TIME;


// UVFunc:6
	vec2 n_in6p1 = vec2(-0.20000, -0.20000);
	vec2 n_out6p0 = vec2(n_out7p0) * n_in6p1 + UV;


	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(BGText, n_out6p0);


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 0.00000;
	float n_in4p2 = 0.00001;
	vec3 n_in4p4 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_in4p5 = vec3(0.00000, 0.00000, 0.00000);
	if(abs(n_out2p4 - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out3p0.xyz);
	}
	else if(n_out2p4 < n_in4p1)
	{
		n_out4p0 = n_in4p5;
	}
	else
	{
		n_out4p0 = n_in4p4;
	}


// MultiplyAdd:5
	vec3 n_in5p1 = vec3(1.00000, 1.00000, 1.00000);
	vec3 n_out5p0 = fma(vec3(n_out2p0.xyz), n_in5p1, n_out4p0);


// Output:0
	ALBEDO = n_out5p0;


}
    
   ���H�7C+   
    ��D   B,             -   
     ��   B.            /   
     �C  �C0            1   
     D  �C2            3   
     HD  HC4            5   
         D6            7   
     ��  D8            9   
     ��  %D:            ;   
     ��  4C<       $                                                                                                               	                   RSRC