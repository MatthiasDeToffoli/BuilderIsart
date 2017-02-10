package com.isartdigital.perle.ui.popin.option;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author Alexis
 */
class ResetDataPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe ResetDataPoppin
	 */
	private static var instance: ResetDataPoppin;
	
	private static var btnCancel: SmartButton;
	private static var btnConfirm: SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ResetDataPoppin {
		if (instance == null) instance = new ResetDataPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.RESET_POPPIN);
		setWireframe();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		SmartCheck.traceChildrens(this);
		btnCancel = cast(getChildByName(AssetName.RESET_POPPIN_CANCEL), SmartButton);
		btnConfirm = cast(getChildByName(AssetName.RESET_POPPIN_CONFIRM), SmartButton);
		
		Interactive.addListenerClick(btnCancel, cancel);
		Interactive.addListenerClick(btnConfirm, confirm);
	}
	
	private function confirm():Void {
		SaveManager.reinit();
	}
	
	private function cancel():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}