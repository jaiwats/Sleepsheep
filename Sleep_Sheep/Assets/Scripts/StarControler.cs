using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarControler : MonoBehaviour
{
    private int sheep_count;
    public GameObject Sheep;
    public GameObject FinalPosition;


    public List<GameObject> Stars;
    // Start is called before the first frame update
    void Start()
    {
        for(int i = 0; i < Stars.Count; i++)
        {
            Stars[i].SetActive(false);
        }
        sheep_count = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if(Mathf.Approximately(Sheep.transform.position.y, FinalPosition.transform.position.y))
        {
            if(sheep_count == Stars.Count)
            {
                for(int i = 0; i < Stars.Count; i++)
                {
                    Stars[i].SetActive(false);
                }
                
                sheep_count = 0;
            }

            Stars[sheep_count].SetActive(true);
            sheep_count++;
        }
        
    }
}
