package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author grenu
 */
class BHConstruction extends BuildingHud{

	private static var instance:BHConstruction;
	
	private var btnMove:SmartButton;
	//private var buildingTimer:BuildingTimerConstruction;
	private var btnDestroy:SmartButton;
	
	public static function getInstance (): BHConstruction {
		if (instance == null) instance = new BHConstruction();
		return instance;
	}	
	
	private function new() {
		super("BuildingContext");	
	}
	
	override public function setOnSpawn():Void {
		setGameListener();	
		/*buildingTimer = new BuildingTimer();
		buildingTimer.spawn();
		addChild(buildingTimer);*/
	}
	
	private function setGameListener():Void {
		GameStage.getInstance().getGameContainer().interactive = true;
		GameStage.getInstance().getGameContainer().on(MouseEventType.MOUSE_UP, onClickExit);
	}
	
	override private function addListeners():Void 
	{
		btnMove = cast(getChildByName("ButtonMoveBuilding"), SmartButton);
		btnDestroy = cast(getChildByName("ButtonCancelConstruction"), SmartButton);
	}
	
	private function onClickExit(pEvent:EventTarget):Void {
		//buildingTimer.destroy();
		removeGameListener();
		Hud.getInstance().hideBuildingHud();
	}
	
	public function onClickDestroy(): Void {
		UIManager.getInstance().openPopin(BuildingDestroyPoppin.getInstance());
		removeGameListener();
	}
	
	
	private function removeGameListener():Void {
		GameStage.getInstance().getGameContainer().off(MouseEventType.MOUSE_UP, onClickExit);
		GameStage.getInstance().getGameContainer().interactive = false;
	}
	
	override public function destroy():Void {
		instance = null;
		//if(buildingTimer != null) buildingTimer.destroy();
		removeGameListener();
		super.destroy();
	}
	
}