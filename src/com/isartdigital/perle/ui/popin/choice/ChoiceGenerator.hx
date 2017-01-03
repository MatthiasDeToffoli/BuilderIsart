package com.isartdigital.perle.ui.popin.choice;

	
/**
 * ...
 * @author grenu
 */
class ChoiceGenerator 
{
	
	/**
	 * instance unique de la classe ChoiceGenerator
	 */
	private static var instance: ChoiceGenerator;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ChoiceGenerator {
		if (instance == null) instance = new ChoiceGenerator();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}