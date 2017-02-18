package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.ui.popin.server.ServerPopinRollback;
import com.isartdigital.perle.ui.UIManager;
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
	public static inline var BUILDING_CANNOT_SELL_DONT_EXIST:Int = 6;
	private static inline var ERROR_PREFIX:String = "ErrorID_";
	
	// todo : ID ci-dessus relié à un élément de traduction pour ensuite afficher une popin d'erreur.
	
	public static function openPopin (pErrorId:Int):Void {
		Debug.warn("Server returned an custom error: " + ERROR_PREFIX + pErrorId);
		
		var lPopin:ServerPopinRollback = new ServerPopinRollback();
		lPopin.setText(FakeTraduction.assetNameNameToTrad("Server returned an custom error."), pErrorId);
		
		UIManager.getInstance().openPopin(lPopin);
		lPopin.init();
	}
	
}