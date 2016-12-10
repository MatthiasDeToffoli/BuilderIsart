package com.isartdigital.perle.ui.popin;

import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author grenu
 */
class Hud extends SmartPopin 
{
	
	/**
	 * instance unique de la classe Hud
	 */
	private static var instance: Hud;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = null;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}