package com.isartdigital.services.monetization;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.UIPosition;
import haxe.Json;
import haxe.Timer;
import js.Browser;
import js.Lib;
import js.html.VideoElement;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;
import pixi.loaders.Loader;

/**
 * Service permettant d'afficher des publicités des autres Builder
 * @author Mathieu Anthoine
 */
class Ads
{

	/**
	 * Publicité vidéo vu jusqu'au bout
	 */
	public static inline var TYPE_END:String = "end";
	
	/**
	 * Annulation du visionnage d'une publicité vidéo ou fermeture d'une publicité image
	 */
	public static inline var TYPE_CANCEL:String = "cancel";
	
	/**
	 * Fermeture d'une publicité image
	 */
	public static inline var TYPE_CLOSE:String = "close";
	
	/**
	 * click sur la publicité
	 */
	public static inline var TYPE_CLICK:String = "click";
	
	/**
	 * pub image
	 */
	private static inline var IMAGE:String = "image";

	/**
	 * pub vidéo
	 */
	private static inline var MOVIE:String = "movie";	
	
	private static var current:Ad;
	
	private static var callback:Dynamic->Void;	

	/**
	 * Demande l'affichage d'un publicité image
	 * @param	pCallback fonction à appelée une fois la publicité affichée et quittée
	 * @return true si la demande d'affichage est acceptée, sinon false (quand une autre pub est en cours)
	 */
	public static function getImage (pCallback:Dynamic->Void): Bool {
		return askForImage(pCallback);
	}
	
	private static function askForImage (pCallback:Dynamic->Void,pVideo:String=""):Bool {
		if (current!=null || (Config.data.ads!=null && !Config.data.ads)) return false;
		
		var lRequest:HttpService = initService(pCallback);
		lRequest.addParameter("ad", IMAGE);
		if (pVideo!="") lRequest.addParameter("movie", pVideo);
		lRequest.request();
		
		return true;
	}
	
	
	/**
	 * Demande l'affichage d'un publicité vidéo
	 * @param	pCallback fonction à appelée une fois la publicité affichée et quittée
	 * @return true si la demande d'affichage est acceptée, sinon false (quand une autre pub est en cours)
	 */
	public static function getMovie (pCallback:Dynamic->Void): Bool {
		if (current!=null || (Config.data.ads!=null && !Config.data.ads)) return false;
		
		if (DeviceCapabilities.isCocoonJS) return getImage(pCallback);
		
		var lRequest:HttpService = initService(pCallback);
		lRequest.addParameter("ad", MOVIE);
		lRequest.request();
		
		return true;
	}
	
	private static function initService (pCallback:Dynamic->Void):HttpService {
		var lRequest:HttpService = new HttpService(pCallback);
		callback = pCallback;
		lRequest.addParameter("type", DeviceCapabilities.textureType);
		lRequest.addParameter("lang", Config.language);
		lRequest.onData = onData;
		return lRequest;
	}
	
	private static function onData (pData:String): Void {
		var lData:Dynamic = Json.parse(pData);
		if (lData.type == MOVIE) current=new AdMovie(lData.id,lData.url,lData.target);
		else current=new AdImage(lData.id,lData.url,lData.target);
		
	}
	
	private static function onQuit (pClose:String):Void {
		var lId:String = current.id;
		current.close();
		current = null;
		
		if (pClose == TYPE_END) askForImage(callback, lId);
		else {
			if (pClose == TYPE_CLOSE || pClose == TYPE_CLICK) {
				var lRequest:HttpService = new HttpService();			
				lRequest.addParameter("close", pClose == TYPE_CLICK ? TYPE_CLICK : IMAGE);
				lRequest.request();
			}
			callback({close:pClose});
			callback = null;
		}
		
	}

}

private class Ad extends Popin {
	
	public var id:String;
	private var url:String;
	private var target:String;
	private var content:Sprite;
	private var btnQuit:Container;
	private var txtQuit:Text;
	private var timer:Timer;
	private var timerError:Timer;
	private var duration:Int;
	
	private static inline var CROSS_SIZE:Int = 20;
	private static inline var QUIT_SIZE:Int = 40;	
	
	public function new (pId:String,pUrl:String,pTarget:String) {
		super();
		modalImage = "assets/black_bg.png";
		
		id = pId;
		url = pUrl;
		target = pTarget;
		
		btnQuit = new Container();
		addChild (btnQuit);
		
		positionables.unshift( { item:btnQuit, align:Math.random() < 0.5 ? UIPosition.TOP_RIGHT : UIPosition.TOP_LEFT , offsetX:80, offsetY:80 } );
		
		var lCircle:Graphics = new Graphics();
		lCircle.lineStyle(4, 0x000000);
		lCircle.beginFill(0xFFFFFF);
		lCircle.drawCircle(0, 0, QUIT_SIZE);
		lCircle.endFill();
		btnQuit.addChild(lCircle);
		
		txtQuit = new Text("", { font: "62px Arial", fill: "#000000", align: "center" } );
		txtQuit.anchor.set(0.5, 0.5);
		btnQuit.addChild(txtQuit);
		btnQuit.interactive = true;
		btnQuit.visible = false;
		timerError = new Timer(15000);
		timerError.run = onError;
		
		x = GameStage.getInstance().safeZone.width / 2;
		y = GameStage.getInstance().safeZone.height / 2;
		
		GameStage.getInstance().addChild(this);
		open();
			
	}
	
	private function onError ():Void {
		if (!btnQuit.visible) {
			btnQuit.visible = true;
			duration = 0;
			onTimer();
		}
		timerError.stop();
		
	}
	
	private function onTimer():Void {
		if (duration <= 0) {
			if (timer!=null) timer.stop();
			allowQuit();
		} else {
			txtQuit.text = Std.string(duration);
		}
		duration--;
	}
	
	private function allowQuit ():Void {
		btnQuit.removeChild(txtQuit);
		var lCross:Graphics = new Graphics();
		lCross.lineStyle(8, 0x000000);
		lCross.moveTo( -CROSS_SIZE, -CROSS_SIZE);
		lCross.lineTo(CROSS_SIZE, CROSS_SIZE);
		lCross.moveTo( -CROSS_SIZE, CROSS_SIZE);
		lCross.lineTo(CROSS_SIZE, -CROSS_SIZE);
		btnQuit.addChild(lCross);
		
		btnQuit.buttonMode = true;
		btnQuit.once(MouseEventType.CLICK, onQuit);
		btnQuit.once(TouchEventType.TAP, onQuit);
	}
	
	private function createContent ():Void {}
	
	private function onComplete(?pEvent:Loader=null):Void {
		createContent();
		content.anchor.set(0.5, 0.5);
		content.scale.set(1 /DeviceCapabilities.textureRatio , 1 / DeviceCapabilities.textureRatio);
		addChildAt(content, 0);
		
		timer = new Timer(1000);
		duration = Math.random() < 0.5 ? 0 : 5;
		timer.run = onTimer;
		onTimer();
		btnQuit.visible = true;
	}
	
	private function quit (pType:String):Void {
		GameStage.getInstance().removeChild(this);
		untyped Ads.onQuit(pType);
	}
	
	private function onQuit (pEvent:EventTarget):Void {
	}
	
	override public function close (): Void {
		if (timer!=null) timer.stop();
		if (timerError!=null) timerError.stop();
		super.close();
	}
}

private class AdImage extends Ad {
	public function new (pId:String,pUrl:String,pTarget:String) {
		super(pId,pUrl, pTarget);
		
		var lLoader:Loader = new Loader();
		lLoader.add(url);
		lLoader.once(LoadEventType.COMPLETE, onComplete);
		lLoader.load();
	}
	
	override private function onComplete (?pEvent:Loader = null):Void {
		super.onComplete(pEvent);
		content.interactive = true;
		content.buttonMode = true;
		content.once(MouseEventType.CLICK, onOpen);
		content.once(TouchEventType.TAP, onOpen);
	}
	
	override private function createContent ():Void {
		content = new Sprite(Texture.fromImage(url));
	}
	
	private function onOpen (pEvent:EventTarget):Void {
		Browser.window.open(target+"?"+Type.getClassName(Type.getClass(this)).split(".").pop());
		quit(Ads.TYPE_CLICK);
	}
	
	override private function onQuit (pEvent:EventTarget):Void {
		quit (Ads.TYPE_CLOSE);
	}
}

private class AdMovie extends Ad {
	
	public function new (pId:String,pUrl:String,pTarget:String) {
		super(pId,pUrl, pTarget);
		onComplete();
	}
	
	override private function onComplete (?pEvent:Loader=null):Void {
		super.onComplete(pEvent);
		
		if (DeviceCapabilities.textureType == DeviceCapabilities.TEXTURE_LD) {
			content.scale.x *= 0.8;
			content.scale.y *= 0.8;
		}
		
	}
	
	override private function createContent ():Void {
		var texture:Texture = Texture.fromVideoUrl(url);
		var source:VideoElement = texture.baseTexture.source;
		
		source.crossOrigin = "anonymous";
		
		content = new Sprite(texture);
		cast(content.texture.baseTexture.source, VideoElement).onended = onEnded;
		//Timer.delay(onEnded, 1000);		
		
	}

	override private function onQuit (pEvent:EventTarget):Void {
		quit (Ads.TYPE_CANCEL);
	}	
	
	private function onEnded ():Void {
		quit(Ads.TYPE_END);
	}
	
	override public function close ():Void {
		if (content != null) {
			cast(content.texture.baseTexture.source, VideoElement).onended = null;
			cast(content.texture.baseTexture.source, VideoElement).pause();
		}
		super.close();
	}
	
}
