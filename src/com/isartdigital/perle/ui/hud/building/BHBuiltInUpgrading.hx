package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.popin.accelerate.SpeedUpPopin;
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
	private var btnSpeedUp:SmartButton;
	
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
		btnSpeedUp = cast(getChildByName("ButtonSkip_SmallConstruction"), SmartButton);
		super.findElements();
	}
	
	override public function setOnSpawn():Void 
	{
		Interactive.addListenerClick(btnCancel, onClickCancel);
		Interactive.addListenerClick(btnSpeedUp, onSpeedUp);
		super.setOnSpawn();
		addListeners();
	}
	
	override function removeButtonsChange():Void 
	{
		Interactive.removeListenerClick(btnCancel, onClickCancel);
		super.removeButtonsChange();
	}
	
	override function addListeners():Void 
	{		
		super.addListeners();
		btnSpeedUp = cast(getChildByName("ButtonSkip_SmallConstruction"), SmartButton);
		Interactive.addListenerClick(btnSpeedUp, BHConstruction.getInstance().onSpeedUp);
		Interactive.addListenerClick(btnCancel, onClickCancel);
	}
	
	private function onClickCancel():Void {
		trace("cancel upgrade");
	}
	
	private function onSpeedUp():Void {
		UIManager.getInstance().closeCurrentPopin();
		SpeedUpPopin.linkBuilding(BuildingHud.virtualBuilding);
		UIManager.getInstance().openPopin(SpeedUpPopin.getInstance());
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnCancel, onClickCancel);
		Interactive.removeListenerClick(btnSpeedUp, BHConstruction.getInstance().onSpeedUp);
		
		instance = null;
		super.destroy();
	}

}