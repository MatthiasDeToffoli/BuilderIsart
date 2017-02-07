package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.ui.popin.InternHousePopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author Alexis
 */
class BHBuiltUndestoyable extends BuildingHud
{
	
	private var btnMove:SmartButton;
	private var btnDescription:SmartButton;

	public function new(pID:String=null) 
	{
		super(pID);
		findElements();
	}
	
	/**
	 * function to set when the WF is openned
	 */
	override public function setOnSpawn():Void {
		
		InfoBuilding.virtualBuilding = BuildingHud.virtualBuilding;
		GameStage.getInstance().getBuildContainer().interactive = true;
		GameStage.getInstance().getBuildContainer().on(MouseEventType.MOUSE_DOWN, onClickExit);
		setMoveAndDestroy();
		setDescriptionButton();
		
	}
	
	private function setDescriptionButton():Void {
		Interactive.addListenerClick(btnDescription, onClickDescription);
	}
	
	private function removeButtonsChange():Void {
		Interactive.removeListenerClick(btnMove, onClickMove);
	}
	
	private function findElements():Void 
	{
		btnMove = cast(getChildByName("MoveButton"), SmartButton);
		btnDescription = cast(getChildByName("EnterButton"), SmartButton);
	}
	
	public function removeListenerGameContainer():Void {
		GameStage.getInstance().getBuildContainer().interactive = false;
		GameStage.getInstance().getBuildContainer().off(MouseEventType.MOUSE_DOWN, onClickExit);
	}
	
	private function onClickMove(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		BuildingHud.virtualBuilding.onClickMove();
		
		Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING, BuildingHud.virtualBuilding);
	}
	
	private function onClickDescription(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		Hud.getInstance().hide();
		openInfoBuilding();
		onClickExit();
	}
		
	private function openInfoBuilding():Void {
		if (BuildingHud.virtualBuilding == null) return;
		if (Std.is(BuildingHud.virtualBuilding, VInternHouse)) UIManager.getInstance().openPopin(InternHousePopin.getInstance()); 
		else {
			InfoBuilding.virtualBuilding = BuildingHud.virtualBuilding;
			UIManager.getInstance().openPopin(InfoBuilding.getInstance());
		}
	}
	
	/**
	 * listen click on destroy and move if building is not the tribunal
	 */
	public function setMoveAndDestroy():Void{
		Interactive.addListenerClick(btnMove, onClickMove);
	}
	
	private function onClickExit():Void {
		removeButtonsChange();
		GameStage.getInstance().getBuildContainer().interactive = false;
		GameStage.getInstance().getBuildContainer().off(MouseEventType.MOUSE_DOWN, onClickExit);
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnMove, onClickMove);
		
		Interactive.removeListenerClick(btnDescription, onClickDescription);
		
		removeListenerGameContainer();
		super.destroy();
	}
	
}