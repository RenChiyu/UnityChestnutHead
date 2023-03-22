/*
 * @Author: Chiyu Ren
 * @Date: 2023-02-14 15:48
 * @LastEditors: Chiyu Ren
 * @LastEditTime: 2023-03-23 00:05
 * @FileName: ChestnutHead.cs
 * @Description: 控制投影球的旋转
 */
using UnityEngine;


[ExecuteInEditMode]
public class ChestnutHead : MonoBehaviour
{
    [SerializeField]
    private float xRotation = 0;
    [SerializeField]
    private float yRotation = 0;
    [SerializeField]
    private float zRotation = 0;

    private Material mat;

    private readonly int TRS_ID = Shader.PropertyToID("_TRSMatrix");


    private void Start()
    {
        this.mat = base.GetComponent<MeshRenderer>().sharedMaterial;
        this.Process();
    }


    private void OnValidate()
    {
        this.Process();
    }


    private void Process()
    {
        if (this.mat == null)
        {
            return;
        }

        var rotation = Quaternion.Euler(this.xRotation, this.yRotation, this.zRotation);
        var trs = Matrix4x4.TRS(Vector3.zero, rotation, Vector3.one);
        this.mat.SetMatrix(TRS_ID, trs);
    }
}