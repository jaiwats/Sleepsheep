using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waves_Move_Up : MonoBehaviour
{
    public GameObject Sheep;
    private Vector3 position_0;
    public GameObject Position_2;
    private bool UP;
    public float speed;

    void Start()
    {
        UP = true;
        position_0 = Sheep.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if(Sheep.transform.position == position_0)
        {
            UP = true;
        }
        
        if(Mathf.Approximately(Sheep.transform.position.y,Position_2.transform.position.y))
        {
            UP = false;
        }

        if(UP == true)
        {
            transform.Translate(0,0,-0.01f);
        }
        else if(UP == false)
        {
            transform.position = Vector3.MoveTowards(transform.position, Position_2.transform.position, speed * Time.deltaTime);
        }
        
    }
}
