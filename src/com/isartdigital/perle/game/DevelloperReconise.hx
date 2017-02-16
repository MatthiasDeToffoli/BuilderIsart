package com.isartdigital.perle.game;
import com.isartdigital.services.facebook.Facebook;

/**
 * ...
 * @author de Toffoli Matthias
 */
class DevelloperReconise
{

	private static var devs:Array<String>;
	
	public static function awake():Void {
		devs = [
			"10206357042724082"
		];
	}
	
	public static function isDev():Bool {
		var lId:String;
		
		for (lId in devs) if (Facebook.uid == lId) return true;
		
		return false;
	}
	
}