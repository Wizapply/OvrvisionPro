// OculusLensShader.h
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
// OpenGL 2.1 : GLSL 1.2

#ifndef __DATA_OCULUSLENSSHADER_H__
#define __DATA_OCULUSLENSSHADER_H__

//Oculus Lens Distort Shader for OpenGL

//OpenGL GLSL Vertexshader
const char* ols_vertexshader =
{
    "#version 120\n"
	"\n"
	"attribute vec2 position;\n"
	"attribute float timewarpLerpFactor;\n"
	"attribute float vignette;\n"
	"attribute vec2 texCoord0;\n"
	"attribute vec2 texCoord1;\n"
	"attribute vec2 texCoord2;\n"
	"\n"
	"uniform vec2 eyeToSourceUVscale;\n"
	"uniform vec2 eyeToSourceUVoffset;\n"
	"uniform mat4 eyeRotationStart;\n"
	"uniform mat4 eyeRotationEnd;\n"
	"\n"
	"varying vec2 oTexCoord0;\n"
	"varying vec2 oTexCoord1;\n"
	"varying vec2 oTexCoord2;\n"
	"varying float oVignette;\n"
	"\n"
	"vec2 timeWarpTexCoord(vec2 texCoord, mat4 rotMat)\n"
	"{\n"
	"    vec3 transformed = (rotMat * vec4(texCoord.xy, 1.0, 1.0)).xyz;\n"
	"    vec2 flattened = transformed.xy / transformed.z;\n"
	"    return eyeToSourceUVscale * flattened + eyeToSourceUVoffset;\n"
	"}\n"
	"\n"
	"void main() {\n"
	"    mat4 lerpedEyeRot = eyeRotationStart * (1.0 - timewarpLerpFactor) + eyeRotationEnd * timewarpLerpFactor;\n"
	"    oTexCoord0 = timeWarpTexCoord(texCoord0, lerpedEyeRot);\n"
	"    oTexCoord1 = timeWarpTexCoord(texCoord1, lerpedEyeRot);\n"
	"    oTexCoord2 = timeWarpTexCoord(texCoord2, lerpedEyeRot);\n"
	"    gl_Position = vec4(position.x, position.y, 0.5, 1.0);\n"
	"    oVignette = vignette;\n"
	"}\n"
};


//OpenGL GLSL Flagmentshader
const char* ols_flagshader =
{
	"#version 120\n"
	"\n"
	"uniform sampler2D texture0;\n"
	"\n"
	"varying vec2 oTexCoord0;\n"
	"varying vec2 oTexCoord1;\n"
	"varying vec2 oTexCoord2;\n"
	"varying float oVignette;\n"
	"\n"
	"void main() {\n"
	"    float r = texture2D(texture0, oTexCoord0).r;\n"
	"    float g = texture2D(texture0, oTexCoord1).g;\n"
	"    float b = texture2D(texture0, oTexCoord2).b;\n"
	"    gl_FragColor = vec4(r, g, b, 1.0);\n"
	"}\n"
};

#endif /*__DATA_OCULUSLENSSHADER_H__*/
