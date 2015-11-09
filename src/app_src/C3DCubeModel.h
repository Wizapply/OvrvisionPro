// C3DCubeModel.h
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

#ifndef __C3DCUBEMODEL_H__
#define __C3DCUBEMODEL_H__

/////////// INCLUDE //////////

// Include the Wizapply
#include "wizapply.h"				//!<Common Header
#include <ovrvision_ar.h>

/////////// CLASS ///////////

class C3DCubeModel
{
public:
	C3DCubeModel();
	~C3DCubeModel();

	//Method
	// Create/Delete
	bool CreateModel(float size);
	void DeleteModel();
	// Draw
	void DrawModel(wzMatrix* pView, wzMatrix* pProj, wzVector3* gap = NULL);
	void DrawARModel(OVR::OvMarkerData* data, wzMatrix* pProj, wzVector3* gap = NULL);

private:

	bool m_isCreated;

	//For Draw
	//Mesh data
	wzMesh	m_cube;
	//Shader data
	wzShaderProg m_shader;
	//Texture data
	wzTexture m_texture;	/*not use*/
};

#endif /*__C3DCUBEMODEL_H__*/
