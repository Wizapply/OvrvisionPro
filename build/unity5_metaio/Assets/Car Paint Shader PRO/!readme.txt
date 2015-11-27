Car Paint Shader PRO 2.5
--------------------
Car Paint Shader PRO is approach to efficient and photorealistic 3D visualize of your game 3D models.

Information
-----------
Pack includes 17 shaders :
- Car General
- Car Paint
- Car Paint Advanced
- Car Paint Per Pixel Lightning
- Car Paint Duo Color
- Car Paint with Alpha Blending
- Car Paint with Bump Maping and Reflection & Refraction
- Car Paint with Double Bump Maping and Reflection & Refraction
- Car Glass Shader with Reflection and Fresnel Formula
- Car Glass Shader with Bump Maping and Reflection & Refraction
- Car Glass Shader Advanced
- Car Chrome Shader
- Car Paint with Decal (mixed with _Color)
- Car Paint with Livery (color independent)
- Car Paint with Reflection Mask
- Car Paint with Decal without reflection
- Car Paint Matte

Features :
- DX9 DX11 OpenGL ready
- Unity 3.5 & Unity 4.x ready
- Up to 4 Lights Sources + Directional Light
- Full Self Shadowing and Shadow Casting
- Works in Forward and Deferred Rendering
- Diffuse and Ambient Color
- Specular Color with Gloss
- Bump Mapping
- Reflection Cubemap
- Reflection Fresnel
- Real Time Reflections (Unity Pro)
- Decal with alpha control (for stickers, mud)
- Flakes with 3 prepared sparkle textures fully adjustable via shader parameters

DirectX 11
----------
If you wanna use shaders under DX11 - unpack ZIP from Shaders directory and use DX11 shaders.

Real Reflection Script (Unity Pro Only!)
----------------------------------------
Simply drag and drop script into your object and in runtime it will generate and replace Cubemap to rendered one. 
Notice that objects should be on separate layer!

Script parameters :
- Cubemap Size : Size in pixels of generated cubemap
- Cubemap Far Clip : How far cubemap camera will render objects
- One Face Per Frame : It will render only one face per frame. Its very good for optimizing game.
- Camera Offset : You can change offset of camera that is rendering. Sometimes object pivot is under ground so you can shift it to be more up
- Also On Childs : Assign rendered cubemap on objects children. Its better to have one time cubemap render and set it on childs than rendered separate cubemap for each object.

Version History
---------------
1.0 Initial Version
1.1 Added 2 more shaders (CarPaint Duo Color, CarPaint with Alpha)
1.2 Added Chrome Shader
1.3 Fixed Chrome Shader
1.4 Fixed OpenGL compatibility
1.5 Added Car Paint Decal shader
1.55 Optimisation + default Flake Power 0.0
1.6 Fixed fresnel formula
1.7 Added Livery Shader - Livery Texture color is independent from material _Color
1.8 Added 2 new shaders : Decal without Reflection + Paint with Reflection Mask
1.9 --skipped--
2.0 Added Car Model with sample setup scene
	Optimised ALL shaders for better performance
2.1 Added Double Bump Car Paint Shader
2.2 Added Car Glass Advanced
	Added Car Paint Per Pixel Lightning (ALPHA VERSION)
	Added Car General Shader (for tires, plastic etc)
	Shaders are now compatible with Glow Effect from Unity
2.2.1 Fixed self shadowing problems
2.3 Added Car Paint Advanced Shader
	Optimized Car Paint Shader
	Added first 5 DX11 Shaders (ZIP file inside Shaders directory)
	Redone balls sample scene
2.4 Added Car Paint Matte Shader
2.5 Added Real Time Reflection script with sample scene

Credits
-------
Red Dot Games 2013
http://www.reddotgames.pl