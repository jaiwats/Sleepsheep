using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enviorment_Shift : MonoBehaviour
{
    public float DegreeChange;
    public GameObject Sheep;
    public GameObject FinalPos;
    private bool turn;
    private int count; 
    // Start is called before the first frame update
    void Start()
    {
        count = 0;
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Mathf.Approximately(Sheep.transform.position.y, FinalPos.transform.position.y))
        {
            if(turn)
            {
                transform.RotateAround(FinalPos.transform.position,transform.forward, -1 * DegreeChange);
                count++;
                if(count >= 6)
                {
                    count = 0;
                    turn = false;
                }
            }
            else
            {
                transform.RotateAround(FinalPos.transform.position,transform.forward, DegreeChange);
                count++; 
                if(count >= 6)
                {
                    count = 0;
                    turn = true;
                }
            }
            
        }
        
    }
}
