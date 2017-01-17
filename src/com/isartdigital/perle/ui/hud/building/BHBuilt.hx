package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class BHBuilt extends BuildingHud
{

	private var btnMove:SmartButton;
	private var btnDescription:SmartButton;
	private var btnUpgrade:SmartButton;
	private var btnDestroy:SmartButton;

	
	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	/**
	 * function to set when the WF is openned
	 */
	public function setOnSpawn():Void {
		trace(BuildingHud.virtualBuilding);
		InfoBuilding.virtualBuilding = BuildingHud.virtualBuilding;
		GameStage.getInstance().getBuildContainer().interactive = true;
		GameStage.getInstance().getBuildContainer().on(MouseEventType.MOUSE_DOWN, onClickExit);
		setUpgradeButton();
		setMoveAndDestroy();
		setDescriptionButton();
		
	}
	
	/**
	 * listen click on destroy and move if building is not the tribunal
	 */
	public function setMoveAndDestroy():Void{

			btnMove.on(MouseEventType.CLICK, onClickMove);		
			btnDestroy.on(MouseEventType.CLICK, onClickDestroy);
		
	}
	
	private function setDescriptionButton():Void {
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade) || Std.is(BuildingHud.virtualBuilding, VTribunal)){
			btnDescription.alpha = 1;
			btnDescription.on(MouseEventType.CLICK, onClickDescription);
		}
		else {
			btnDescription.alpha = 0.5;
			btnDescription.off(MouseEventType.CLICK, onClickDescription);
		}
	}
	
	private function setUpgradeButton():Void {
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade)){
				var myVBuilding:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
				trace(myVBuilding.getLevel());
				if (myVBuilding.canUpgrade()) {
					btnUpgrade.on(MouseEventType.CLICK, onClickUpgrade);
				}
				else
					btnUpgrade.alpha = 0.5;
			}
		else btnUpgrade.alpha = 0.5;
	}
	
	private function removeButtonsChange():Void {
			
		btnMove.off(MouseEventType.CLICK, onClickMove);		
		btnDestroy.off(MouseEventType.CLICK, onClickDestroy);
		btnUpgrade.removeAllListeners();
		btnUpgrade.alpha = 1;
		btnMove.alpha = 1;
		btnDestroy.alpha = 1;
	}
	
	override function addListeners():Void 
	{
		btnMove = cast(getChildByName("MoveButton"), SmartButton);
		btnDescription = cast(getChildByName("EnterButton"), SmartButton);
		btnUpgrade = cast(getChildByName("ButtonUpgradeBuilding"), SmartButton);
		btnDestroy = cast(getChildByName("ButtonDestroyBuilding"), SmartButton);
		//btnDescription.on(MouseEventType.CLICK, onClickDescription);
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
		if(Std.is(BuildingHud.virtualBuilding,VTribunal)) UIManager.getInstance().openPopin(TribunalPopin.getInstance()); 
		else {
			InfoBuilding.virtualBuilding = BuildingHud.virtualBuilding;
			UIManager.getInstance().openPopin(InfoBuilding.getInstance());
		}
		onClickExit();
	}
	
	public function onClickDestroy(): Void {
		removeButtonsChange();
		UIManager.getInstance().openPopin(BuildingDestroyPoppin.getInstance());
		removeListenerGameContainer();
	}
	
	private function onClickUpgrade(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		InfoBuilding.getInstance().onClickUpgrade();
		Hud.getInstance().hideBuildingHud();
	}
	
	private function onClickExit():Void {
		removeButtonsChange();
		GameStage.getInstance().getBuildContainer().interactive = false;
		GameStage.getInstance().getBuildContainer().off(MouseEventType.MOUSE_DOWN, onClickExit);
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void {
		removeListenerGameContainer();
		super.destroy();
	}
	
}