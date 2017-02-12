package com.isartdigital.perle.ui.gauge;

import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author Alexis
 */
class LoadingBar extends SmartComponent 
{
	
	/**
	 * instance unique de la classe LoadingBar
	 */
	private static var instance: LoadingBar;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LoadingBar {
		if (instance == null) instance = new LoadingBar();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super("loading");
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}