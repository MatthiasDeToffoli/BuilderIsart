package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.building.VirtuesBuilding;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author ambroise
 */
class InfoBuilding extends SmartPopin {
	
	/**
	 * instance unique de la classe InfoBuilding
	 */
	private static var instance: InfoBuilding;
	
	private var btnExit:SmartButton;
	private var btnSell:SmartButton;
	private var btnUpgrade:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): InfoBuilding {
		if (instance == null) instance = new InfoBuilding();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super(AssetName.POPIN_INFO_BUILDING);
		
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_CLOSE), SmartButton);
		btnSell = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_SELL), SmartButton);
		btnUpgrade = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_UPGRADE), SmartButton);
		
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnSell.on(MouseEventType.CLICK, onClickSell);
		
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade)){
			var myVBuilding:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
			if (myVBuilding.canUpgrade()){
				btnUpgrade.on(MouseEventType.CLICK, onClickUpgrade);
				return;
			}
		}
		
		btnUpgrade.parent.removeChild(btnUpgrade);
		btnUpgrade.destroy();
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickSell ():Void {
		BuyManager.sell(cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName());
		UIManager.getInstance().closeCurrentPopin();
		BuildingHud.virtualBuilding.destroy();
		Hud.getInstance().hideBuildingHud();
		SaveManager.save();
	}
	
	private function onClickUpgrade ():Void {
		var lAssetName:String = BuildingHud.virtualBuilding.tileDesc.assetName;
		var lBuildingUpgrade:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
		
		lBuildingUpgrade.onClickUpgrade(BuildingHud.virtualBuilding);
		UIManager.getInstance().closeCurrentPopin();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}