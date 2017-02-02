package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author ambroise
 */
class BHMoving extends BuildingHud{

	private static var instance:BHMoving;
	
	private var btnCancel:SmartButton;
	private var btnConfirm:SmartButton;
	
	
	public static function getInstance (): BHMoving {
		if (instance == null) instance = new BHMoving();
		return instance;
	}	
	
	private function new() {
		var lmyAssetName:String = DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP ?
						 AssetName.HUD_MOVNG_BUILDING : AssetName.HUD_MOVNG_BUILDING_DESKTOP;
		
		super(lmyAssetName);
	}
	
	public function cantBuildHere ():Void {
		trace("Can't Build Here !"); // todo: feedback
	}
	
	override private function addListeners ():Void {
		// TODO : décommenté quand assetName à jour , qui ne fera plus bugué le jeu.
		//btnCancel = cast(SmartCheck.getChildByName(this, AssetName.HUD_MOVNG_BUILDING_BTN_CANCEL), SmartButton);
		//Interactive.addListenerClick(btnCancel, onClickCancel);
		
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) {
			btnConfirm = cast(SmartCheck.getChildByName(this, AssetName.HUD_MOVNG_BUILDING_BTN_CONFIRM), SmartButton);
			Interactive.addListenerClick(btnConfirm, onClickConfirm);
		}
	}
	
	private function onClickCancel ():Void {
		if (BuildingHud.virtualBuilding == null) {
			Phantom.onClickCancelBuild();
			Hud.getInstance().hideBuildingHud();
		}
		else {
			BuildingHud.virtualBuilding.onClickCancel();
			Hud.getInstance().changeBuildingHud(BuildingHudType.HARVEST, BuildingHud.virtualBuilding);
		}
	
		Building.isClickable = true;
	}
	
	private function onClickConfirm ():Void {
		if (BuildingHud.virtualBuilding == null)
			Phantom.onClickConfirmBuild();
		else
			BuildingHud.virtualBuilding.onClickConfirm();
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnCancel, onClickCancel);
		Interactive.removeListenerClick(btnConfirm, onClickConfirm);
		
		instance = null;
		super.destroy();
	}
	
}