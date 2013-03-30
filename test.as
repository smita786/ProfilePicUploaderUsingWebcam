package {
import flash.events.MouseEvent;
import com.adobe.images.JPGEncoder;
import flash.events.Event;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.media.Video;
import flash.utils.ByteArray;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.display.Stage;
import flash.display.Sprite;
import flash.net.URLRequestMethod;
import flash.display.DisplayObject;
import flash.net.URLVariables;
import flash.display.MovieClip;
import flash.net.navigateToURL;
import flash.events.*;
import flash.text.TextField;
import flash.text.TextFormat;
public class test extends Sprite{
var video:Video;
var camera:Camera;
var imgBA:ByteArray;
var imgBD:BitmapData;
var imgBitmap:Bitmap;
var phpPath:String;
var jpgEncoder:JPGEncoder;
var sendHeader:URLRequestHeader;
var sendReq:URLRequest;
var sendLoader:URLLoader;
var imagePath:String;
var shotBtn:Sprite = new Sprite();
var removeBtn:Sprite = new Sprite();
var sendBtn:Sprite = new Sprite();
public function test(){
setupCamera(500,350);
setupApplication();
drawButton(shotBtn,110,350);
addChild(shotBtn);
}
function setupCamera(w:int,h:int):void {
	try {
		camera = Camera.getCamera();
	} catch(e:Error) {
		trace("No Camera detected!");
	}
	camera.addEventListener(StatusEvent.STATUS, camStatusHandler);
	camera.setMode(w,h,stage.frameRate);
	video = new Video(w,h);
	video.attachCamera(camera);
	addChild(video);
}
function camStatusHandler(event:StatusEvent):void {
	// Camera.Muted or Camera.Unmuted -> User's security
	trace(event.code);
}
function setupApplication():void {
	shotBtn.addEventListener(MouseEvent.CLICK, createSnapshot);
	removeBtn.addEventListener(MouseEvent.CLICK, removeSnapshot);
	//sendBtn.addEventListener(MouseEvent.CLICK, sendImage);
	phpPath = "saveimg.php"
	jpgEncoder = new JPGEncoder(90);
	sendHeader = new URLRequestHeader("Content-type","application/octet-stream");
	sendReq = new URLRequest(phpPath);
	sendReq.requestHeaders.push(sendHeader);
	sendReq.method = URLRequestMethod.POST;
	sendLoader = new URLLoader();
	sendLoader.addEventListener(Event.COMPLETE,imageSentHandler);
}
function createSnapshot(event:MouseEvent):void {
	imgBD = new BitmapData(video.width,video.height);
	imgBD.draw(video);
	imgBitmap = new Bitmap(imgBD);
	addChild(imgBitmap);
	shotBtn.removeEventListener(MouseEvent.CLICK, createSnapshot);
	sendImage();
	video.attachCamera(null); //If you pass in null, will remove the camera
	removeChild(video);
	video = null;
	camera = null;
	removeChild(shotBtn);
}
function removeSnapshot(event:MouseEvent):void {
	removeChild(imgBitmap);
	shotBtn.addEventListener(MouseEvent.CLICK, createSnapshot);
}
function sendImage():void {
	imgBA = jpgEncoder.encode(imgBD);
	sendReq.data = imgBA;
	sendLoader.load(sendReq);
}
function imageSentHandler(event:Event):void {
	var dataStr:String = event.currentTarget.data.toString();
	var resultVars:URLVariables = new URLVariables();
	resultVars.decode(dataStr);
	imagePath = "http://" + resultVars.base + "/" + resultVars.filename;
	trace("Uploaded to: " + imagePath);
}
private function drawButton(button:Sprite,x:int,y:int):void {
              var textLabel:TextField = new TextField()
              button.graphics.clear();
              button.graphics.beginFill(0xD4D4D4); // grey color
              button.graphics.drawRoundRect(x, y, 280, 125, 10, 10); // x, y, width, height, ellipseW, ellipseH
              button.graphics.endFill();
              textLabel.text = "Capture Me!";
              textLabel.x = x+65;
              textLabel.y = y+10;
              textLabel.width = 250;
var myFormat:TextFormat = new TextFormat();  

myFormat.size = 24;  
 
myFormat.bold = true;  

textLabel.setTextFormat(myFormat);  

              textLabel.selectable = false;
              button.addChild(textLabel)
          }
}
}
