package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltInUpgrading extends BHBuiltUndestoyable 
{
	
	/**
	 * instance unique de la classe BHBuiltInUpgrading
	 */
	private static var instance: BHBuiltInUpgrading;
	private var btnCancel:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHBuiltInUpgrading {
		if (instance == null) instance = new BHBuiltInUpgrading();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.CONTEXTUAL_IN_UPGRADING);
		
	}
	
	override function findElements():Void 
	{
		btnCancel = cast(getChildByName(AssetName.CONTEXTUAL_BTN_CANCEL), SmartButton);
		super.findElements();
	}
	
	override public function setOnSpawn():Void 
	{
		Interactive.addListenerClick(btnCancel, onClickCancel);
		super.setOnSpawn();
	}
	
	override function removeButtonsChange():Void 
	{
		Interactive.removeListenerClick(btnCancel, onClickCancel);
		super.removeButtonsChange();
	}
	
	private function onClickCancel():Void {
		trace("cancel upgrade");
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnCancel, onClickCancel);
		instance = null;
		super.destroy();
	}

}