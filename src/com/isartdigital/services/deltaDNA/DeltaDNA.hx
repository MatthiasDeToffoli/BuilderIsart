package com.isartdigital.services.deltaDNA;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Http;
import haxe.Json;

typedef DeltaDNAEvent =
{
	var eventName:String;
	var userID:String;
	var sessionID:String;
	var eventParams:Dynamic;
}

typedef DeltaDNAEngage =
{
	var decisionPoint:String;
	var userID:String;
	var sessionID:String;
	var platform:String;
	var parameters: Dynamic;	
}

/**
 * Classe permettant d'envoyer des données à la plateforme DeltaDNA 
 * @author Mathieu Anthoine
 */
class DeltaDNA
{

	public static inline var GAME_STARTED:String = "gameStarted";
	public static inline var GAME_ENDED:String = "gameEnded";
	public static inline var CLIENT_DEVICE:String = "clientDevice";
	public static inline var NEW_PLAYER:String = "newPlayer";	
	
	private static var userID:String;
	private static var sessionID:String;
	private static var platform:String;
	
	private static var devices:Map<String,String> = 	[
						DeviceCapabilities.SYSTEM_ANDROID => "ANDROID",
						DeviceCapabilities.SYSTEM_IOS => "IOS",
						DeviceCapabilities.SYSTEM_BLACKBERRY => "BLACKBERRY_MOBILE",
						DeviceCapabilities.SYSTEM_BB_PLAYBOOK => "BLACKBERRY_TABLET",
						DeviceCapabilities.SYSTEM_WINDOWS_MOBILE => "WINDOWS_MOBILE",
						DeviceCapabilities.SYSTEM_DESKTOP => "PC_CLIENT"
															];
	
	private static var collectURL : String;
	private static var engageURL : String;
	
	private static var devKey : String;
	private static var liveKey : String;
	
	public static var onData:String->Void;
	public static var onError:String->Void;
	public static var onGetUserID:String->Void;	
	
	private static var list:Array<DeltaDNAEvent> = [];
	
	private static function _onData (pData:String): Void {
		trace ("DeltaDNA success: "+pData);
	}
	
	private static function _onError (pError:String): Void {
		trace ("DeltaDNA error: "+pError);
	}	
	
	private static function _onGetUserID (pData:String):Void {
		trace (Json.parse(pData).userID);
	}
		
	private static function request (pRequest:Http):Void {
		pRequest.onError = onError;
		pRequest.request(true);
	}
	
	/**
	 * initialise le service
	 */
	public static function init (pDevKey:String, pLiveKey:String, pCollectURL:String, pEngageURL:String,pUserID:String,pSessionID:String):Void {
		collectURL = pCollectURL;
		engageURL = pEngageURL;
		devKey = pDevKey;
		liveKey = pLiveKey;		
		userID = pUserID;
		sessionID = pSessionID;
		platform = devices[DeviceCapabilities.system];
	}
	
	/**
	 * Récupère un userID
	 */
	public static function getUserID ():Void {
		var lRequest:Http=new Http(collectURL+"/uuid");
		lRequest.onData = onGetUserID == null ? _onGetUserID : onGetUserID;
		lRequest.onError = onError==null ? _onError : onError;
		request(lRequest);
		
	}
	
	/**
	 * Permet d'ajouter un event DeltaDNA à la liste des events
	 * @param	pEventName Nom de l'event
	 * @param	pParams Objet décrivant les paramètres à transmettre
	 */
	public static function addEvent (pEventName:String,pParams:Dynamic=null):Void {			
		
		if (pParams == null) pParams = {};
		pParams.platform = platform;
		var lEvent:DeltaDNAEvent ={
			eventName:pEventName,
			userID:userID,
			sessionID:sessionID,
			eventParams: pParams
		};
		
		list.push(lEvent);
	}
	
	/**
	 * Permet d'envoyer tous les events ajoutés
	 * @param	pLive Event LIVE ou DEV
	 */
	public static function send (pLive:Bool=false):Void {
		var lJson:Dynamic;
		var lSuffix:String = "";
		
		if (list.length == 1) lJson = list[0];
		else if (list.length > 1) {
			lJson = { eventList : list }
			lSuffix = "/bulk";
		}
		else {
			trace("DeltaDNA: Pas d'Event à envoyer");
			return;
		}
		
		var lUrl:String = collectURL + "/" + (pLive ? liveKey : devKey) + lSuffix;
		
		var lRequest:Http = new Http(lUrl);
		lRequest.addHeader("Content-Type", "application/json");
		lRequest.setPostData(Json.stringify(lJson));
		lRequest.onData = onData==null ? _onData : onData;
		lRequest.onError = onError==null ? _onError : onError;
		request(lRequest);
		
		list = [];
		
	}
	
	/**
	 * Permet d'interroger la platforme DeltaDNA sur la disponibilité de campagnes
	 * @param	pDecisionPoint le point de décision interrogé
	 * @param	pParams Objet décrivant les paramètres à transmettre
	 */
	public static function engage (pDecisionPoint:String,pLive:Bool=false,pParams:Dynamic=null):Void {
		
		if (pParams == null) pParams = {};
		var lUrl: String = engage + "/" + (pLive ? liveKey : devKey);
		
		var lEngage:DeltaDNAEngage=  {
			decisionPoint: pDecisionPoint,
			userID: userID,
			sessionID: sessionID,
			platform: platform,
			parameters: pParams
		};
		
		var lUrl:String = engageURL + "/" + (pLive ? liveKey : devKey);
		
		var lRequest:Http = new Http(lUrl);
		lRequest.addHeader("Content-Type", "application/json");
		lRequest.setPostData(Json.stringify(lEngage));
		lRequest.onData = onData==null ? _onData : onData;
		lRequest.onError = onError==null ? _onError : onError;
		request(lRequest);
		
	}
	
}
