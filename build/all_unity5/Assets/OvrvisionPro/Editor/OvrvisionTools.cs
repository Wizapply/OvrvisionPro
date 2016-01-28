using UnityEngine;
using System.Collections;
using UnityEditor;

public class OvrvisionTools : EditorWindow
{
	//Create MenuItem
	[MenuItem("OvrvisionPro/Add OvrvisionProCamera", false, 10)]
	static void AddOvrvisionProCamera()
	{
		if (GameObject.Find("OvrvisionProCamera") == null)
		{
			//Eliminate other camera objects.
			Camera[] camObjs = GameObject.FindObjectsOfType(typeof(Camera)) as Camera[];
			foreach (Camera camobj in camObjs)
			{
				string delName = camobj.gameObject.name;
				if (UnityEditor.EditorUtility.DisplayDialog(delName + " : Competition!", "Do you inactivate the unnecessary camera[" + delName + "] object which will cause the problem?", "YES", "NO"))
				{
					camobj.gameObject.SetActive(false);
				}
			}

			CreateLayer(24, "OvrvisionProLeftImage");
			CreateLayer(25, "OvrvisionProRightImage");

			Object obj = Instantiate(Resources.Load("Prefabs/OvrvisionProCamera"), new Vector3(0.0f, 0.0f, 0.0f), Quaternion.identity);
			obj.name = "OvrvisionProCamera";

			//Force Virtual mode.
			PlayerSettings.virtualRealitySupported = true;
		}
		else
		{
			UnityEditor.EditorUtility.DisplayDialog("Error!", "The add failed. [OvrvisionProCamera] object already exists in this scene.", "OK");
		}
	}

	[MenuItem("OvrvisionPro/Add OvrvisionARTracker", false, 30)]
	static void AddOvrvisionARTracker()
	{
		if (GameObject.Find("OvrvisionTracker") == null)
		{
			Object obj = Instantiate(Resources.Load("Prefabs/OvrvisionTracker"), new Vector3(0.0f, 0.0f, 0.0f), Quaternion.identity);
			obj.name = "OvrvisionTracker";
		}
		else
		{
			UnityEditor.EditorUtility.DisplayDialog("Error!", "The add failed. [OvrvisionTracker] object already exists in this scene.", "OK");
		}
	}

	[MenuItem("OvrvisionPro/Add OvrvisionHandTracker", false, 40)]
	static void AddOvrvisionHandTracker()
	{
		if (GameObject.Find("OvrvisionHandTracker") == null)
		{
			Object obj = Instantiate(Resources.Load("Prefabs/OvrvisionHandTracker"), new Vector3(0.0f, 0.0f, 0.0f), Quaternion.identity);
			obj.name = "OvrvisionHandTracker";
		}
		else
		{
			UnityEditor.EditorUtility.DisplayDialog("Error!", "The add failed. [OvrvisionHandTracker] object already exists in this scene.", "OK");
		}
	}

	[MenuItem("OvrvisionPro/Add ShadowPlane for Ovrvision", false, 60)]
	static void AddShadowPlane_for_Ovrvision()
	{

	}

	//Create Layer
	static void CreateLayer(int num, string layerName)
	{
		SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);

		SerializedProperty layers = tagManager.FindProperty("layers");
		if (layers == null || !layers.isArray)
		{
			Debug.LogWarning("Can not set up the layers.  It is possible the format of the layers and tags data has changed in this version of Unity.");
			Debug.LogWarning("Layers is null: " + (layers == null));
			return;
		}

		SerializedProperty layerSP = layers.GetArrayElementAtIndex(num);
		if (layerSP.stringValue == "")
		{
			layerSP.stringValue = layerName;
			tagManager.ApplyModifiedProperties();
		}
		else if (layerSP.stringValue != layerName)
		{
			UnityEditor.EditorUtility.DisplayDialog("Error!", "The layer is competing with others. Please confirm layer information. ", "OK");
		}
	}
}