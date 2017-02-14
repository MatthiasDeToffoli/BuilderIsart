package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author ambroise
 */
class ErrorManager{
	
	public static inline var BUILDING_CANNOT_MOVE_COLLISION:Int = 1;
	public static inline var BUILDING_CANNOT_MOVE_DONT_EXIST:Int = 2;
	public static inline var BUILDING_CANNOT_BUILD_OUTSIDE_REGION:Int = 3;
	public static inline var BUILDING_CANNOT_BUILD_COLLISION:Int = 4;
	public static inline var BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY:Int = 5;
	private static inline var ERROR_PREFIX:String = "ErrorID_";
	
	// todo : ID ci-dessus relié à un élément de traduction pour ensuite afficher une popin d'erreur.
	
	public static function openPopin (pErrorId:Int):Void {
		Debug.warn("Server returned an custom error: " + ERROR_PREFIX + pErrorId);
		// todo : si la traduction se base sur les données de la bdd, alros mieux vaut directement envoyé ce qui doit être affiché avec un code d'erreur.
		trace("message in popin translated : " + FakeTraduction.errorCodeToTrad(ERROR_PREFIX + pErrorId));
		
	}
	
}