Vtx bluefire_bluefire_mesh_layer_5_vtx_0[4] = {
	{{{-100, -100, 0}, 0, {-16, 2032}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{100, -100, 0}, 0, {2032, 2032}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{100, 100, 0}, 0, {2032, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-100, 100, 0}, 0, {-16, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
};

Gfx bluefire_bluefire_mesh_layer_5_tri_0[] = {
	gsSPVertex(bluefire_bluefire_mesh_layer_5_vtx_0 + 0, 4, 0),
	gsSP1Triangle(0, 1, 2, 0),
	gsSP1Triangle(0, 2, 3, 0),
	gsSPEndDisplayList(),
};


Gfx mat_bluefire_Fire[] = {
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, TEXEL0, TEXEL0, 0, ENVIRONMENT, 0, 0, 0, 0, TEXEL0, TEXEL0, 0, ENVIRONMENT, 0),
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 1, bluefire_fire00180000_rgba16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 4095, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b, 16, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 6, 0, G_TX_WRAP | G_TX_NOMIRROR, 6, 0),
	gsDPSetTileSize(0, 0, 0, 252, 252),
	gsSPEndDisplayList(),
};

Gfx mat_revert_bluefire_Fire[] = {
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_CULL_BACK),
	gsSPEndDisplayList(),
};

Gfx bluefire_bluefire_mesh_layer_5[] = {
	gsSPDisplayList(mat_bluefire_Fire),
	gsSPDisplayList(bluefire_bluefire_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_bluefire_Fire),
	gsSPEndDisplayList(),
};

Gfx bluefire_material_revert_render_settings[] = {
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

