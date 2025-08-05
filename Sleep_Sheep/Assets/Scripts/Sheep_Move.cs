using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sheep_Move : MonoBehaviour
{
    //speed and sheep position and Sheep color generation
    public float speed;
    private Vector3 original_position; 
    public List<Color> SheepColor;
    public List<Color> WhispColor;
    private int SheepNumber;
    private int WhispNumber;

    //final destination
    public GameObject FinalPos;
    private Vector3 POSFinal;

    //material
    public Material SheepMaterial;
    public float alpha = 1f;

    //For Stars
    private int sheep_count = 0;
    public List<GameObject> Stars;

    //Enviorment
    public float DegreeChange;
    private bool turn;
    private int count; 
    public GameObject EnviormentCotroler;

    //Start and end of experince
    public Camera vrCamera; // Assign the VR camera in the inspector
    public float maxDistance = 1000f;
    public LayerMask targetLayer; // Optional: assign specific layers to detect
    public bool StartSheep = false;


    //Only for the first fade in
    private bool FadeStart = false;
    private bool NoFadeAnymore = false;

    //Trail Texture
    public Material TrailTexture;
    public float Trailalpha;

    //Sound
    public AudioSource StarSound;

    //Ending
    public List<Material> ConstilationMaterial;
    private bool Ending = false;
    public List<float> AlpahOfConstinaltions;
    public Color baseEmissionColor;
    public Material BridgeMaterial;
    public float BrindgeApha;


    void Start()
    {
        //For sheep color at the start
        SheepNumber = 0;
        WhispNumber = 0;

        //Bringe Aplpha
        BrindgeApha = 0.09f;
        original_position = this.gameObject.transform.position;

        //Stars
        for(int i = 0; i < Stars.Count; i++)
        {
            Stars[i].SetActive(false);
        }

        count = 0;
        alpha = 0;

        for(int i = 0; i < 12; i++)
        {
            AlpahOfConstinaltions[i] = -0.1f;
        }

        Trailalpha = 0;
    }

    void FixedUpdate()
    {

        Ray ray = new Ray(vrCamera.transform.position, vrCamera.transform.forward);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            StartSheep = true;
            if(NoFadeAnymore == false)
            {
                FadeStart = true;
                NoFadeAnymore = true;
            }
        }

        else
        {
            StartSheep = false;
        }
    }

    // Update is called once per frame
    void Update()
    {

        //For trail texture
        TrailTexture.SetFloat("_Static", Trailalpha);

        //For Final Constilation
        BridgeMaterial.SetFloat("_GlobalAlpha", BrindgeApha);
        for(int i = 0; i < 12; i++)
        {
            ConstilationMaterial[i].SetColor("_EmissionColor", baseEmissionColor * AlpahOfConstinaltions[i]);;
        }


        //For fade start
        if(FadeStart == true)
        {
            StartCoroutine(FadeIn());
            FadeStart = false;
        }

        //For Sheep Postion
        if(StartSheep == true && Ending == false)
        {

        SheepMaterial.SetFloat("_GlobalAlpha", alpha);

        POSFinal = FinalPos.transform.position;

        var step = speed * Time.deltaTime;
        
        this.gameObject.transform.position = Vector3.MoveTowards(this.gameObject.transform.position,POSFinal,step);
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject== FinalPos)
        {
            StartCoroutine(FadeFunctionOut());
        }
    }

    private IEnumerator FadeFunctionOut()
    {
        //Sheep Fading out
        for(int i = 0; i < 160; i++)
        {
            yield return new WaitForSeconds(0.1f);
            alpha = alpha-0.00625f;
            Trailalpha = Trailalpha -0.00625f;
        }


        //Star ending 
        if(sheep_count == Stars.Count)
        {
            Ending = true;
        }

        if(Ending == false)
        {
            //Star Settig
            Stars[sheep_count].SetActive(true);
            sheep_count++;

            //Enviorment
            if(turn)
                {
                    EnviormentCotroler.transform.RotateAround(FinalPos.transform.position,EnviormentCotroler.transform.forward, -1 * DegreeChange);
                    count++;
                    if(count >= 6)
                    {
                        count = 0;
                        turn = false;
                    }
                }
                else
                {
                    EnviormentCotroler.transform.RotateAround(FinalPos.transform.position,EnviormentCotroler.transform.forward, DegreeChange);
                    count++; 
                    if(count >= 6)
                    {
                        count = 0;
                        turn = true;
                    }
                }

            //Sheep teleporing back
            this.gameObject.transform.position =  original_position; 

            //Sheep fading back in 
            StartCoroutine(FadeIn());
        }

        else
        {
            StartCoroutine(StarFinale());
        }

    }

    //For Fade In
    private IEnumerator FadeIn()
    {
        SheepMaterial.SetColor( "_RimColor", SheepColor[SheepNumber]);
        TrailTexture.SetColor("_OuterTint", WhispColor[WhispNumber]);
        for(int i = 0; i < 80; i++)
        {
            yield return new WaitForSeconds(0.1f);
            alpha = alpha+0.0125f;
            Trailalpha = Trailalpha +0.00625f;
        }

        for(int i = 0; i<10; i++)
        {
            yield return new WaitForSeconds(0.1f);
            Trailalpha = Trailalpha +0.05f;
        }

        SheepNumber =  Random.Range(0, 4);
        WhispNumber =  Random.Range(0, 4);

    }

    //Star ending seqence
    private IEnumerator StarFinale()
    {

        for(int i = 0; i < 100; i++)
        {
            yield return new WaitForSeconds(0.1f);
            BrindgeApha = BrindgeApha - 0.001f;
        }

        for(int i = 0; i < 12; i++)
        {
            for(int j = 0; j < 51; j++)
            {
                yield return new WaitForSeconds(0.1f);
                AlpahOfConstinaltions[i] = AlpahOfConstinaltions[i]+0.02f;
            }
            
        }
    }
}
