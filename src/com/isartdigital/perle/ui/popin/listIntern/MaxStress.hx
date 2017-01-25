package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author Emeline Berenguier
 */
class MaxStress extends SmartPopin 
{
	
	/**
	 * instance unique de la classe MaxStress
	 */
	private static var instance: MaxStress;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MaxStress {
		if (instance == null) instance = new MaxStress();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.INTERN_EVENT_MAX_STRESS);
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}