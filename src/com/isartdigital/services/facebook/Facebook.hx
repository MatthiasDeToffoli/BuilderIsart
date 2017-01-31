package com.isartdigital.services.facebook;

import com.isartdigital.services.facebook.events.FacebookEventType;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Json;
import haxe.Timer;
import js.Browser;
import js.html.Element;
import js.html.HTMLDocument;
import js.html.ScriptElement;
import js.html.SourceElement;

/**
 * Classe haxe permettant l'accès à l'api Facebook 
 * @author Mathieu Anthoine
 * @version 0.2.0
 */
class Facebook
{
	/**
	 * reference vers l'objet Facebook Js ou CocoonJs
	 */
	private static var fb:Dynamic;
	
	/**
	 * access token
	 */
	public static var token (default, null):String;

	/**
	 * user id
	 */
	public static var uid (default, null):String;	
	
	/**
	 * paramètres d'initialisation
	 */
	private static var params:FacebookParams = { xfbml:true, version:"v2.8", cookie:true };
	
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
	 * callback de déconnexion
	 */
	public static var onLogout:Response->Void;
	
	/**
	 * callback d'annulation d'une fenetre
	 */
	public static var onCancel:Response-> Void;
	
	/**
	 * Le plugin ou le SDK n'est pas chargé
	 */
	public static var onNotReady:Void->Void;
	
	/**
	 * Chargement et connexion à l'app Facebook
	 * @param	pAppId
	 * @param	pPermissions
	 * @param	pParams
	 */
	public static function load (pAppId:String,?pPermissions:Permissions=null,?pParams:FacebookParams=null):Void {
		if (fb != null) {
			trace ("Facebook already initialized. Action aborded.");
			return;
		}
		
		if (pParams != null) params = pParams;
		params.appId = pAppId; 
		
		if (pPermissions!=null) permissions = pPermissions;	
		
		if (DeviceCapabilities.isCocoonJS) {
			Timer.delay(onCocoonJsLoaded, 1000);
		} else {
			untyped Browser.window.fbAsyncInit = initBrowser;
		
			var lDoc:HTMLDocument = Browser.window.document;
			var lScript:String = "script";
			var lID:String = "facebook-jssdk";
			var lJs:ScriptElement;
			var lFjs:Element = lDoc.getElementsByTagName(lScript)[0];
					
			if (lDoc.getElementById(params.appId)!=null) return;
			
			lJs = cast (lDoc.createElement(lScript),ScriptElement);
			lJs.id = lID;
			lJs.src = "//connect.facebook.net/en_US/sdk.js";
			lFjs.parentNode.insertBefore(lJs, lFjs);		
		}
		
	}
	
	/**
	 * Initialisation du plugin Facebook pour CocoonJs
	 */
	private static function onCocoonJsLoaded ():Void {
		if (untyped Browser.window.Cocoon && untyped Browser.window.Cocoon.Social && untyped Browser.window.Cocoon.Social.Facebook) {
			fb = untyped Browser.window.Cocoon.Social.Facebook;
			fb.init(params, initCocoonJs);
        } else {
			trace ('Cocoon Facebook Plugin not installed');
		}
		
	}
	
	/**
	 * Initialisation asynchrone de la lib Facebook pour navigateur
	 */
	private static function initBrowser ():Void {	
		fb = untyped FB;
		fb.init(params);		
		fb.getLoginStatus(onLoginStatus);		
	}
	
	/**
	 * callback d'initialisation du plugin Facebook pour CocoonJs
	 * @param	pError
	 */
	private static function initCocoonJs (pError:Dynamic) {
		if (pError != null) trace ("Init CocoonJs: " + pError);
		else if (pError==false) {
			if (onCancel != null) onCancel({status:"Facebook app not installed"});
			else trace ("Facebook app not installed");
		} else {
			fb.on("loginStatusChanged", onLoginStatus);
			fb.getLoginStatus(onLoginStatus);
		}
		
	}
	
	/**
	 * Permet de déterminer su un utilisateur est loggé dans Facebook et si il ne l'est pas tente de le connecter automatiquement
	 * @param	pResponse
	 */
	private static function onLoginStatus (pResponse:Response):Void {
		
		trace (Json.stringify(pResponse));
		
		if (pResponse.status == FacebookEventType.CONNECTED) {
			token = pResponse.authResponse.accessToken;
			uid = pResponse.authResponse.userID;
			if (onLogin != null) onLogin();
			else trace ("Facebook Log in");
		} else if (isFirstAttempt) {
			trace ("Facebook retry Log in");
			isFirstAttempt = false;
			login();
		} else if (pResponse.status == FacebookEventType.UNKNOWN) {
			if (onCancel != null) onCancel(pResponse);
			else trace ("Facebook canceled Log in");
		} else {
			if (onCancel != null) onCancel(pResponse);
			else trace ("Facebook canceled action");
		}
	}
	
	/**
	 * Ouvre la popin de Log in et permet à l'utilisateur de se logger
	 * Est automatiquement appelé par Facebook.load
	 */
	public static function login ():Void {
		if (fb == null) notReady();
		else if (DeviceCapabilities.isCocoonJS) fb.login(permissions);
		else fb.login(onLoginStatus, permissions);
	}
	
	public static function logout ():Void {
		if (fb == null) notReady();
		else fb.logout(_onLogout);
	}
	
	private static function _onLogout (pResponse:Response): Void {
		if (onLogout != null) onLogout(pResponse);
		else trace ("Facebook Log out");
	}
	
	/**
	 * informations de l'application une fois connectée
	 */
	public static function getAuthResponse ():AuthResponse {
		if (fb == null) {
			notReady();
			return null;
		}
		return fb.getAuthResponse();
	}
	
	private static function notReady ():Void {
		//TODO: il faut une callback ici pour pouvoir ajouter une popup d'alerte disant qu'il faut se coneccter ou proposer une fenetre de connexion
		if (onNotReady != null) onNotReady();
		if (DeviceCapabilities.isCocoonJS) trace ("Cocoon Facebook Plugin not loaded");
		else trace ("Facebook SDK not loaded");
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
		if (fb == null) notReady();
		else {
			if (DeviceCapabilities.isCocoonJS) {
				if (pParams == null) {
					pCallBack = pMethod;
					pParams = {};
					pMethod = "get";
				} else if (pCallBack == null) {
					pCallBack = pParams;
					pMethod = "get";
				}
				pParams.access_token = token;
			}
			fb.api(pPath, pMethod, pParams, pCallBack);
		}
	}
	
	/**
	 * permet de déclencher l'apparition de différentes fenêtres de dialogue UI
	 * @param	pParams paramètres de la fenêtre appelée
	 * @param	pCallBack function appelée à la fermeture de la fenêtre de dialogue
	 */
	public static function ui (pParams:Dynamic,?pCallBack:Dynamic->Void): Void {
		if (fb == null) notReady();
		else {
			if (DeviceCapabilities.isCocoonJS) pParams.app_id = params.appId;
			fb.ui (pParams, pCallBack);
		}
	}

	
}


