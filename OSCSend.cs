
//script adapted from http://gameaudiomiddleware.tumblr.com/post/21680680198/inside-unity3d-1-udp-network



using UnityEngine;
using System.Collections;
using System.Net.Sockets;
using System.Text;
using System.Collections;

public class OSCSend : MonoBehaviour {

	private UdpClient clientP = new UdpClient();
	private ASCIIEncoding byteEncoder = new ASCIIEncoding();
	private string lastInput;

	// Use this for initialization
	void Start () {
		//clientP.Connect("127.0.0.1", 6666);
		clientP.Connect ("255.255.255.255", 6666);
		lastInput = "";
	}
	
	// Update is called once per frame
	void Update () {
		float xPercent = 100 * (Input.mousePosition.x / Screen.width);
		float yPercent = 100-(100 * (Input.mousePosition.y / Screen.height));

		SendInt ("mouseX:", (int)xPercent);
		SendInt ("mouseY:", (int)yPercent);
		Debug.Log ("xpercent = " + xPercent + "  ypercent = " + yPercent);

		if (Input.inputString != ""){
			if (Input.inputString != lastInput){
				SendString ("key:" + Input.inputString);
				Debug.Log ("sending " + Input.inputString);
			}
		}
		
		if (Input.GetKey(KeyCode.UpArrow)){
			SendString("dir:" + "UP");
		}
		if (Input.GetKey(KeyCode.DownArrow)){
			SendString("dir:" + "DOWN");
		}
		if (Input.GetKey(KeyCode.LeftArrow)){
			SendString("dir:" + "LEFT");
		}
		if (Input.GetKey(KeyCode.RightArrow)){
			SendString("dir:" + "RIGHT");
		}
		if (Input.GetKey(KeyCode.Mouse0))
			SendString("mouseClick:" + "mLEFT");


		if (Input.GetKey(KeyCode.Mouse1))
			SendString("mouseClick:" + "mRIGHT");
		

				lastInput = Input.inputString;
	}
	
	public void SendInt(string routeString, int value){
		string message = routeString + " " + value;
		byte[] messageBytes = byteEncoder.GetBytes(message);
		SendBytes(messageBytes);
		
	}
	public void SendString(string routeString){
		string message = routeString;
		byte[] messageBytes = byteEncoder.GetBytes(message);
		SendBytes(messageBytes);
		
	}

	public void SendBytes(byte[] message){
		try {
			clientP.Send (message, message.Length);

		} catch(SocketException e){
			Debug.Log ("no udp response: " + e);
		}

	}
}
