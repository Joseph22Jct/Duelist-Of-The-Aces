RSRC                     VisualShader            ��������                                            >      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    parameter_name 
   qualifier    texture_type    color_default    texture_filter    texture_repeat    texture_source    script    source    texture    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        1   local://VisualShaderNodeTexture2DParameter_ierwb       &   local://VisualShaderNodeTexture_kkpm7 Z         local://VisualShader_xqtc5 �      #   VisualShaderNodeTexture2DParameter             Texture 	                  VisualShaderNodeTexture                                                VisualShader 	         �   shader_type spatial;
uniform sampler2D Texture : filter_nearest;



void fragment() {
	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(Texture, UV);
	float n_out3p4 = n_out3p0.a;


// Output:0
	ALBEDO = vec3(n_out3p0.xyz);
	ALPHA = n_out3p4;


}
    
   ��]����B(   
     HD  C)             *   
     ��  4C+            ,   
     �C  4C-                                                         RSRC