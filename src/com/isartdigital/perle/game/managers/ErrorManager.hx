package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author ambroise
 */
class ErrorManager{

	private static inline var ERROR_PREFIX:String = "ErrorID_";
	private static inline var BUILDING_CANNOT_BUILD:Int = 0;
	
	// todo : ID ci-dessus relié à un élément de traduction pour ensuite afficher une popin d'erreur.
	
	public static function openPopin (pErrorId:Int):Void {
		Debug.warn("Server returned an custom error: " + ERROR_PREFIX + pErrorId);
		trace("message in popin translated : " + FakeTraduction.errorCodeToTrad(ERROR_PREFIX + pErrorId));
	}
	
}