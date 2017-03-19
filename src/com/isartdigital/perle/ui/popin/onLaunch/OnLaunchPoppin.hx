package com.isartdigital.perle.ui.popin.onLaunch;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.SmartPopinExtended;

	
/**
 * ...
 * @author Rafired
 */
class OnLaunchPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe OnLaunchPoppin
	 */
	private static var instance: OnLaunchPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): OnLaunchPoppin {
		if (instance == null) instance = new OnLaunchPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.ONLAUNCH_POPPIN);
		SmartCheck.traceChildrens(this);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}