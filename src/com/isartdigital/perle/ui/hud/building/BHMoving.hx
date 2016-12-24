package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.events.MouseEventType;
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
	
	public function new() {
		super("MovingBuilding");
	}
	
	public function cantBuildHere ():Void {
		trace("Can't Build Here !");
	}
	
	override private function addListeners ():Void {
		btnCancel = cast(getChildByName("Button_CancelMovement"), SmartButton);
		btnConfirm = cast(getChildByName("Button_ConfirmMovement"), SmartButton);
		btnCancel.on(MouseEventType.CLICK, onClickCancel);
		btnConfirm.on(MouseEventType.CLICK, onClickConfirm);
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
	}
	
	private function onClickConfirm ():Void {
		if (BuildingHud.virtualBuilding == null)
			Phantom.onClickConfirmBuild();
		else
			BuildingHud.virtualBuilding.onClickConfirm();
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}