package com.isartdigital.utils.system;

import com.isartdigital.utils.game.GameStage;
import js.Browser;
import js.html.Element;
import js.html.Event;
import js.html.Image;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
	
/**
 * Classe Utilitaire donnant accès à des propriétés du périphérique cible
 * Tous les périphériques ne se comportant pas comme on l'attend, DeviceCapabilities permet de
 * masquer les comportement différents et présenter une facade unique au reste du code
 * @version 0.4.0
 * @author Mathieu ANTHOINE
 */
class DeviceCapabilities 
{		

	public static inline var SYSTEM_ANDROID: String = "Android";
	public static inline var SYSTEM_IOS: String = "iOS";
	public static inline var SYSTEM_BLACKBERRY: String = "BlackBerry";
	public static inline var SYSTEM_BB_PLAYBOOK: String = "BlackBerry PlayBook";
	public static inline var SYSTEM_WINDOWS_MOBILE: String = "IEMobile";
	public static inline var SYSTEM_DESKTOP: String = "Desktop";	
	
	private static var fullScreenButton:Image;
	private static inline var ICON_SIZE:Float = 0.11;

	public static inline var TEXTURE_NO_SCALE: String = "";
	public static inline var TEXTURE_HD: String = "hd";
	public static inline var TEXTURE_MD: String = "md";
	public static inline var TEXTURE_LD: String = "ld";	
	
	private static var texturesRatios: Map<String,Float> = ["hd"=>1,"md"=>0.5,"ld"=>0.25];
	
	public static var textureRatio (default,null):Float = 1;
	public static var textureType (default,null):String = TEXTURE_NO_SCALE;	
	
	private static var screenRatio:Float = 1;
	
	/**
	  * hauteur du Canvas (change avec l'orientation)
	  */
	public static var height (get, never) : UInt;
	
	private static function get_height () {
		return Browser.window.innerHeight;
	}
	
	/**
	  * largeur du Canvas (change avec l'orientation)
	  */
	public static var width (get, never) : UInt;
	
	private static function get_width () {
		return Browser.window.innerWidth;
	}
	
	/**
	 * Système d'exploitation du Device
	 */
	public static var system (get, never) : String;
	
	private static function get_system( ) {
		if ( ~/IEMobile/i.match(Browser.navigator.userAgent)) return SYSTEM_WINDOWS_MOBILE;	
		else if ( ~/iPhone|iPad|iPod/i.match(Browser.navigator.userAgent)) return SYSTEM_IOS;
		else if ( ~/BlackBerry/i.match(Browser.navigator.userAgent)) return SYSTEM_BLACKBERRY;
		else if ( ~/PlayBook/i.match(Browser.navigator.userAgent)) return SYSTEM_BB_PLAYBOOK;
		else if ( ~/Android/i.match(Browser.navigator.userAgent)) return SYSTEM_ANDROID;
		else return SYSTEM_DESKTOP;
	}
	
	/**
	 * Est-ce que le jeu est encapsulé dans CocoonJs
	 */
	public static var isCocoonJS (get, never) : Bool;
	
	private static function get_isCocoonJS () {
		return untyped Browser.navigator.isCocoonJS || untyped Browser.window.CocoonJS!=null;
	}
	
	/**
	 * Est-ce que le jeu tourne en mode Canvas+ ou Webview+ sous CocoonJS
	 */
	public static var isCanvasPlus (get, never) : Bool;
	
	private static function get_isCanvasPlus () {
		return untyped Browser.navigator.isCocoonJS && untyped Browser.window.CocoonJS != null;
	}
	
	/** 
	
	/**
	 * affiche le bouton de fullscreen
	 */
	public static function displayFullScreenButton ():Void {
		if (isCocoonJS) return;
		
		if (!~/(iPad|iPhone|iPod)/g.match(Browser.navigator.userAgent) && !~/MSIE/i.match(Browser.navigator.userAgent) /*&& !(Browser.window.location.hash = !!Browser.window.MSInputMethodContext)*/) {

			Browser.document.onfullscreenchange = onChangeFullScreen;
			untyped Browser.document.onwebkitfullscreenchange = onChangeFullScreen;
			untyped Browser.document.onmozfullscreenchange = onChangeFullScreen;
			untyped Browser.document.onmsfullscreenchange = onChangeFullScreen;
			//Browser.document.addEventListener("MSFullscreenChange", onChangeFullScreen );
			
			fullScreenButton = new Image();
			fullScreenButton.style.position = 'absolute';
			fullScreenButton.style.right = '0px';
			fullScreenButton.style.top = '0px';
			fullScreenButton.style.cursor = "pointer";
			fullScreenButton.width = Std.int(getSizeFactor()*ICON_SIZE);
			fullScreenButton.height = Std.int(getSizeFactor()*ICON_SIZE);
			fullScreenButton.onclick = enterFullscreen;
			fullScreenButton.src = Config.assetsPath+"fullscreen.png";
			
			Browser.document.body.appendChild(fullScreenButton);

		}		
	}

	/**
	 * entre dans le mode fullscreen
	 * @param	pEvent
	 */
	private static function enterFullscreen(pEvent:Event):Void {
		var lDocElm:Element = Browser.document.documentElement;
		if (lDocElm.requestFullscreen!=null) lDocElm.requestFullscreen();
		else if (untyped lDocElm.mozRequestFullScreen!=null) untyped lDocElm.mozRequestFullScreen();
		else if (untyped lDocElm.webkitRequestFullScreen!=null) untyped lDocElm.webkitRequestFullScreen();
		else if (untyped lDocElm.msRequestFullscreen!=null) untyped lDocElm.msRequestFullscreen();
		
	}

	/**
	 * sort du mode fullscreen
	 */
	private static function exitFullscreen():Void {
		if (Browser.document.exitFullscreen!=null) Browser.document.exitFullscreen();
		else if (untyped Browser.document.mozCancelFullScreen!=null) untyped Browser.document.mozCancelFullScreen();
		else if (untyped Browser.document.webkitCancelFullScreen!=null) untyped Browser.document.webkitCancelFullScreen();
		else if (untyped Browser.document.msExitFullscreen) untyped Browser.document.msExitFullscreen();
	}

	/**
	 * callback appelée sur changement d'état fullscreen
	 * @param	pEvent
	 */
	private static function onChangeFullScreen (pEvent:Event):Void {
		if (untyped Browser.document.fullScreen || untyped Browser.document.mozFullScreen || untyped Browser.document.webkitIsFullScreen || untyped Browser.document.msFullscreenElement) {
			fullScreenButton.style.display = 'none';
		} else {
			fullScreenButton.style.display = 'block';
		}
		pEvent.preventDefault();
	}

	
	/**
	 * Calcul la dimension idéale du bouton en fonction du device
	 * @return fullscreen ideal size
	 */
	public static function getSizeFactor ():Float {
		var lSize:Float=Math.floor(Math.min(width,height));
		if (system == SYSTEM_DESKTOP) lSize /= 3;

		return lSize;
	}
		
	/**
	 * retourne un objet Rectangle correspondant aux dimensions de l'écran dans le repère du DisplayObject passé en paramètre
	 * @param pTarget repère cible
	 * @return objet Rectangle
	 */
	public static function getScreenRect(pTarget:DisplayObject):Rectangle {

		var lTopLeft:Point = new Point (0, 0);
		var lBottomRight:Point = new Point (width, height);
		
		lTopLeft = pTarget.toLocal(lTopLeft);
		lBottomRight = pTarget.toLocal(lBottomRight);
		
		return new Rectangle(lTopLeft.x, lTopLeft.y, lBottomRight.x - lTopLeft.x, lBottomRight.y - lTopLeft.y);
	}

	/**
	 * Calibre le viewport pour que le Browser affiche la résolution réeelle du Device
	 */
	public static function scaleViewport (): Void {
		
		//TODO: COCOONJS
		if (system == SYSTEM_WINDOWS_MOBILE) return;
		
		screenRatio = Browser.window.devicePixelRatio;
		if (!isCocoonJS) Browser.document.write('<meta name="viewport" content="initial-scale=' + Math.round(100 / screenRatio) / 100 + ', user-scalable=no, minimal-ui">');				
		
	}
	
	/**
	 * Défini les ratios de texture
	 * @param	pHd ratio texture pour HD
	 * @param	pMd ratio texture pour MD
	 * @param	pLd ratio texture pour LD
	 */
	public static function init(?pHd:Float = 1, ?pMd:Float = 0.5, ?pLd:Float = 0.25):Void {

		texturesRatios[TEXTURE_HD]=pHd;
		texturesRatios[TEXTURE_MD]=pMd;
		texturesRatios[TEXTURE_LD]=pLd;
		
		if (Config.data.texture != null && Config.data.texture!="") textureType = Config.data.texture;
		else {
			var lBW:Float = Math.max (Browser.window.screen.width, Browser.window.screen.height);
			var lBH:Float = Math.min (Browser.window.screen.width, Browser.window.screen.height);
			var lW:Float = Math.max (GameStage.getInstance().safeZone.width,GameStage.getInstance().safeZone.height);
			var lH:Float = Math.min (GameStage.getInstance().safeZone.width,GameStage.getInstance().safeZone.height);
			
			
			var lRatio:Float = Math.min(lBW * screenRatio / lW, lBH * screenRatio / lH);
			
			if (lRatio <= pLd) textureType = TEXTURE_LD;
			else if (lRatio <= pMd) textureType = TEXTURE_MD;
			else textureType = TEXTURE_HD;
		}
		textureRatio = texturesRatios[textureType];
		
	}

}