package com.isartdigital.perle.ui.popin.credits;

import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;

	
/**
 * ...
 * @author Rafired
 */
class CreditPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe CreditPoppin
	 */
	private static var instance: CreditPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CreditPoppin {
		if (instance == null) instance = new CreditPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super("_credits_MC");
		modal = null;
		interactive = true;
		buttonMode = true;
		Interactive.addListenerClick(this, closeCredit);
	}
	
	private function closeCredit():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(this, closeCredit);
		instance = null;
	}

}