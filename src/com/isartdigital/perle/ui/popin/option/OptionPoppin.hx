package com.isartdigital.perle.ui.popin.option;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author Alexis
 */
class OptionPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe OptionPoppin
	 */
	private static var instance: OptionPoppin;
	private static var btnClose:SmartButton;
	private static var btnReset:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): OptionPoppin {
		if (instance == null) instance = new OptionPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.OPTION_POPPIN);
		setWireframe();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		SmartCheck.traceChildrens(this);
		btnClose = cast(getChildByName(AssetName.OPTION_POPPIN_CLOSE), SmartButton);
		btnReset = cast(getChildByName(AssetName.OPTION_POPPIN_RESETDATA), SmartButton);
		Interactive.addListenerClick(btnClose, onClickClose);
		Interactive.addListenerClick(btnReset, resetData);
	}
	
	private function onClickClose() {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function resetData() {
		SaveManager.reinit();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnClose, onClickClose);
		Interactive.removeListenerClick(btnReset, resetData);
		instance = null;
	}

}