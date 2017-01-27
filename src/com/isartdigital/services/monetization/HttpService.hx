package com.isartdigital.services.monetization;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Http;
import haxe.Json;

/**
 * ...
 * @author Mathieu Anthoine
 */
class HttpService extends Http
{

	private var callback:Dynamic->Void;	
	
	public static inline var SERVICE_PATH:String = "://fbgame.isartdigital.com/2018_builder/pedago/broadcast/";
	
	public function new(pCallback:Dynamic->Void=null) 
	{
		
		callback = pCallback;
		super((DeviceCapabilities.isCocoonJS ? "http" : "https") + SERVICE_PATH);
		if (callback!=null) {
			onData = _onData;
			onError = _onError;
		}
		if (Config.debug) addParameter("debug", "");
	}

	private function _onData (pData:String): Void {
		callback(Json.parse(pData));
		callback = null;
	}
	
	private function _onError (pError:String): Void {
		trace (pError);
		callback = null;
	}	
	
}