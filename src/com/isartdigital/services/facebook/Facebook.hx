package com.isartdigital.services.facebook;

import com.isartdigital.services.facebook.events.FacebookEventType;
import js.Browser;
import js.html.Element;
import js.html.HTMLDocument;
import js.html.ScriptElement;
import js.html.SourceElement;

/**
 * Classe haxe permettant l'accès à l'api Facebook 
 * @author Mathieu Anthoine
 */
class Facebook
{

	/**
	 * id de l'app
	 */
	private static var appId:String;
	
	/**
	 * informations de l'application une fois connectée
	 */
	private static var authResponse:AuthResponse;
	
	/**
	 * access token
	 */
	public static var token (default, null):String;

	/**
	 * user id
	 */
	public static var uid (default, null):String;	
	
	/**
	 * permissions de l'application
	 */
	private static var permissions:Permissions = { scope:"user_friends,email" };
	
	/**
	 * premiere demande de Login
	 */
	private static var isFirstAttempt:Bool = true;
	
	/**
	 * callback de connexion
	 */
	public static var onLogin:Void->Void;
	
	/**
	 * callback d'annulation de connexion
	 */
	public static var onCancelLogin:Response->Void;
	
	/**
	 * Initialisation asynchrone de la lib Facebook
	 */
	private static function init ():Void {	
		untyped FB.init({
		  appId      : appId,
		  xfbml      : true,
		  version    : "v2.8"
		});
		
		untyped FB.getLoginStatus(getLoginStatus);
		
	}
	
	/**
	 * Chargement et connexion à l'app Facebook
	 * @param	pAppId
	 */
	public static function load (pAppId:String,?pPermissions:Permissions=null):Void {
		appId = pAppId;
		untyped Browser.window.fbAsyncInit = init;
		
		var lDoc:HTMLDocument = Browser.window.document;
		var lScript:String = "script";
		var lID:String = "facebook-jssdk";
		var lJs:ScriptElement;
		var lFjs:Element = lDoc.getElementsByTagName(lScript)[0];
				
		if (lDoc.getElementById(appId)!=null) return;
		
		if (pPermissions!=null) permissions = pPermissions;		
		
		lJs = cast (lDoc.createElement(lScript),ScriptElement);
		lJs.id = lID;
		lJs.src = "//connect.facebook.net/en_US/sdk.js";
		lFjs.parentNode.insertBefore(lJs, lFjs);
		
	}
	
	/**
	 * Permet de déterminer su un utilisateur est loggé dans Facebook
	 * @param	pResponse
	 */
	private static function getLoginStatus (pResponse:Response):Void {
		if (pResponse.status == FacebookEventType.CONNECTED) {
			authResponse = pResponse.authResponse;
			token = authResponse.accessToken;
			uid = authResponse.userID;
			onLogin();
		} else if (isFirstAttempt || onCancelLogin==null) {
			isFirstAttempt = false;
			untyped FB.login(getLoginStatus, permissions);
		} else onCancelLogin(pResponse);
	}
	
	/**
	 * permet un appel à Graph API
	 * La méthode peut être appelée de différentes facons:
	 * 
	 * Facebook.api (pPath,pCallBack);
	 * Facebook.api (pPath,pParams,pCallBack);
	 * Facebook.api (pPath,pMethod,pParams,pCallBack);
	 * 
	 * @param	pPath path de la graph API
	 * @param	pMethod méthode HTTP ("get","post", "delete")
	 * @param	pParams paramètres à passer à l'appel
	 * @param	pCallBack fonction de retour
	 */
	public static function api (pPath:String,pMethod:Dynamic,?pParams:Dynamic,?pCallBack:Dynamic): Void {
		untyped FB.api(pPath, pMethod, pParams, pCallBack);
	}
	
	/**
	 * permet de déclencher l'apparition de différentes fenêtres de dialogue UI
	 * @param	pParams paramètres de la fenêtre appelée
	 * @param	pCallBack function appelée à la fermeture de la fenêtre de dialogue
	 */
	public static function ui (pParams:Dynamic,?pCallBack:Dynamic->Void): Void {
		untyped FB.ui (pParams, pCallBack);
	}

	
}


