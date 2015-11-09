// C3DCubeModel.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

/////////// INCLUDE ///////////

#include "C3DCubeModel.h"

/////////// VARS AND DEFS ///////////

/*
 *	シェーダプログラムソースGLSL
 */
// バーテックスシェーダ
// 頂点情報とテクスチャＵＶ座標をもらう
static const char* g_c3d_mdsource_vs = {
"attribute vec3 vPos;\n"
"attribute vec3 vNml;\n"
"uniform mat4 u_worldViewProjMatrix;\n"
"varying vec3 v_nml;\n"
"void main(void)\n"
"{\n"
"   v_nml = vNml;\n"
"	gl_Position = u_worldViewProjMatrix * vec4(vPos,1.0);\n"
"}\n"
};

// フラグメントシェーダ
static const char* g_c3d_mdsource_fs = {
"varying vec3 v_nml;\n"
"uniform vec4 u_diffuse;\n"
"uniform vec3 u_lightdiffuse;\n"
"uniform vec3 u_lightdir;\n"
"void main (void)\n"
"{\n"
"   vec4 colors = u_diffuse;"
"	colors *= vec4((u_lightdiffuse * max(dot(v_nml, normalize(u_lightdir)),0) + 0.4) ,1.0);\n"
"   gl_FragColor = colors;\n"
"}\n"
};

/////////// CLASS ///////////

C3DCubeModel::C3DCubeModel()
{
	// 初期化
	memset(&m_cube,0,sizeof(m_cube));
	memset(&m_shader,0,sizeof(m_shader));
	memset(&m_texture,0,sizeof(m_texture));

	m_isCreated = false;
}

C3DCubeModel::~C3DCubeModel()
{
	DeleteModel();
}

bool C3DCubeModel::CreateModel(float size)
{
	if(m_isCreated)
		return false;

	// Shader vertex format
	wzVertexElements ve_var[] = {
		{WZVETYPE_FLOAT3,"vPos"},
		{WZVETYPE_FLOAT3,"vNml"},
		WZVE_TMT()
	};
	
	// Create shader.
	if(wzCreateShader_GLSL(&m_shader,
		g_c3d_mdsource_vs,g_c3d_mdsource_fs,ve_var))
			return false;

	// Create mesh
	float half_width = size * 0.5f;
	float half_depth = size * 0.5f;
	const float vertex_pointer_v[] = {
		-half_width,	0.000,	half_depth,
		half_width,		0.000,	half_depth,
		-half_width,	size,	half_depth,
		-half_width,	size,	half_depth,
		half_width,		0.000,	half_depth,
		half_width,		size,	half_depth,
		-half_width,	size,	half_depth,
		half_width,		size,	half_depth,
		-half_width,	size,	-half_depth,
		-half_width,	size,	-half_depth,
		half_width,		size,	half_depth,
		half_width,		size,	-half_depth,
		-half_width,	size,	-half_depth,
		half_width,		size,	-half_depth,
		-half_width,	0.000,	-half_depth,
		-half_width,	0.000,	-half_depth,
		half_width,		size,	-half_depth,
		half_width,		0.000,	-half_depth,
		-half_width,	0.000,	-half_depth,
		half_width,		0.000,	-half_depth,
		-half_width,	0.000,	half_depth,
		-half_width,	0.000,	half_depth,
		half_width,		0.000,	-half_depth,
		half_width,		0.000,	half_depth,
		half_width,		0.000,	half_depth,
		half_width,		0.000,	-half_depth,
		half_width,		size,	half_depth,
		half_width,		size,	half_depth,
		half_width,		0.000,	-half_depth,
		half_width,		size,	-half_depth,
		-half_width,	0.000,	-half_depth,
		-half_width,	0.000,	half_depth,
		-half_width,	size,	-half_depth,
		-half_width,	size,	-half_depth,
		-half_width,	0.000,	half_depth,
		-half_width,	size,	half_depth,
	};
	const float vertex_pointer_nml[] = {
		0.000000,	0.000000,	1.000000,
		0.000000,	0.000000,	1.000000,
		0.000000,	0.000000,	1.000000,
		0.000000,	0.000000,	1.000000,
		0.000000,	0.000000,	1.000000,
		0.000000,	0.000000,	1.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	1.000000,	0.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	0.000000,	-1.000000,
		0.000000,	-1.000000,	0.000000,
		0.000000,	-1.000000,	0.000000,
		0.000000,	-1.000000,	0.000000,
		0.000000,	-1.000000,	0.000000,
		0.000000,	-1.000000,	0.000000,
		0.000000,	-1.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,
		-1.000000,	0.000000,	0.000000,	
	};
	const float* vertex_pointer[] = {vertex_pointer_v, vertex_pointer_nml};
	if(wzCreateMesh(&m_cube, (void**)&vertex_pointer, ve_var, NULL, 36, 12)) {
		return false;
	}
	wzChangeDrawMode(&m_cube,WZ_MESH_DF_TRIANGLELIST);

	// Created flag
	m_isCreated = true;

	return true;
}

void C3DCubeModel::DeleteModel()
{
	if(!m_isCreated)
		return;

	wzDeleteMesh(&m_cube);
	wzDeleteShader(&m_shader);
	//wzDeleteTexture(&m_texture); not use

	// Deleted flag
	m_isCreated = false;
}

void C3DCubeModel::DrawModel(wzMatrix* pView, wzMatrix* pProj, wzVector3* gap)
{
	if(!m_isCreated)
		return;

	wzMatrix wvpMatans;
	wzVector4 modelColor = VEC4_INIT(1.0f,1.0f,1.0f,1.0f);
	wzVector3 lightColor = VEC3_INIT(1.0f,1.0f,1.0f);
	wzVector3 lightDirection = VEC3_INIT(0.6f,0.7f,1.0f);

	// Matrix multiply
	wzMatrixIdentity(&wvpMatans);
	wzMatrixMultiply(&wvpMatans, pProj, &wvpMatans);
	
	if(gap != NULL) {
		wzMatrix drawcalc;
		wzMatrixTranslation(&drawcalc,gap->x, gap->y, gap->z);
		wzMatrixMultiply(&wvpMatans, &drawcalc, &wvpMatans);
	}

	wzMatrixMultiply(&wvpMatans, pView, &wvpMatans);

	// Shader
	wzUseShader(&m_shader);
	wzUniformMatrix("u_worldViewProjMatrix",&wvpMatans);
	// Color
	wzUniformVector4("u_diffuse",&modelColor);
	wzUniformVector3("u_lightdiffuse",&lightColor);
	wzUniformVector3("u_lightdir",&lightDirection);
	// Drawing
	wzDrawMesh(&m_cube);
}

void C3DCubeModel::DrawARModel(OVR::OvMarkerData* data, wzMatrix* pProj, wzVector3* gap)
{
	wzMatrix modelView;
	wzMatrix drawcalc;

	wzMatrixIdentity(&modelView);

	// translate
	wzMatrixTranslation(&drawcalc,data->translate.x, data->translate.y, data->translate.z);
	wzMatrixMultiply(&modelView,&drawcalc,&modelView);
	// rotation
	wzQuaternion qt = {data->quaternion.x,data->quaternion.y,data->quaternion.z,data->quaternion.w};
	wzQuaternionToMatrix(&drawcalc, &qt);
	wzMatrixMultiply(&modelView,&drawcalc,&modelView);

	DrawModel(&modelView, pProj, gap);
}
