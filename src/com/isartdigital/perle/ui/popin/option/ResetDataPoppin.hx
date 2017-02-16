package com.isartdigital.perle.ui.popin.option;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;

	
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
	
	private static var resetText: TextSprite;
	private static var btnCancelText: TextSprite;
	private static var btnConfirmText: TextSprite;
	
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
		setValues();
		addListeners();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		btnCancel = cast(getChildByName(AssetName.RESET_POPPIN_CANCEL), SmartButton);
		btnConfirm = cast(getChildByName(AssetName.RESET_POPPIN_CONFIRM), SmartButton);
		resetText = cast(getChildByName(AssetName.RESET_POPPIN_TEXT), TextSprite);
		
		btnCancelText = cast(SmartCheck.getChildByName(btnCancel, AssetName.RESET_POPPIN_CANCEL_TEXT), TextSprite);
		btnConfirmText = cast(SmartCheck.getChildByName(btnConfirm, AssetName.RESET_POPPIN_CONFIRM_TEXT), TextSprite);
	}
	
	private function setValues():Void{
		resetText.text = Localisation.allTraductions["LABEL_CONFIRMEDATARESET_RESET_TEXT"];
		btnCancelText.text = Localisation.allTraductions["LABEL_CONFIRMEDATARESET_CANCEL_RESET"];
		btnConfirmText.text = Localisation.allTraductions["LABEL_CONFIRMEDATARESET_CONFIRM_RESET"];
	}
	
	private function setValuesCancelBtn():Void{
		btnCancelText = cast(SmartCheck.getChildByName(btnCancel, AssetName.RESET_POPPIN_CANCEL_TEXT), TextSprite);
		btnCancelText.text = Localisation.allTraductions["LABEL_CONFIRMEDATARESET_CANCEL_RESET"];
	}
	
	private function setValuesConfirmBtn():Void{
		btnConfirmText = cast(SmartCheck.getChildByName(btnConfirm, AssetName.RESET_POPPIN_CONFIRM_TEXT), TextSprite);
		btnConfirmText.text = Localisation.allTraductions["LABEL_CONFIRMEDATARESET_CONFIRM_RESET"];
	}
	
	private function confirm():Void {
		SaveManager.reinit();
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnCancel, cancel);
		Interactive.addListenerRewrite(btnCancel, setValuesCancelBtn);
		Interactive.addListenerClick(btnConfirm, confirm);
		Interactive.addListenerRewrite(btnConfirm, setValuesConfirmBtn);
	}
	
	private function cancel():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(btnCancel, cancel);
		Interactive.removeListenerRewrite(btnCancel, setValuesCancelBtn);
		Interactive.removeListenerClick(btnConfirm, confirm);
		Interactive.removeListenerRewrite(btnConfirm, setValuesConfirmBtn);
	}

}