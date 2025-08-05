using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingClouds : MonoBehaviour
{
    [SerializeField]
    private Vector3 m_DegreesPerSecond = new Vector3(0.1f, 0f, 0f);
    [SerializeField, Range(0, 1)]
    private float m_DegreeScale = 1f;

    private void Update()
    {
        var angles = m_DegreesPerSecond * m_DegreeScale;
        transform.Rotate(angles);
    }
}
