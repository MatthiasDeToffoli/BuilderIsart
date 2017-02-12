package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.timer.SpeedUpPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.UIPosition;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author grenu
 */
class BHConstruction extends BuildingHud {

	private static var instance:BHConstruction;
	
	private var btnMove:SmartButton;
	private var btnDestroy:SmartButton;
	private var btnSpeedUp:SmartButton;
	
	public static var listTimerConstruction:Map<Int, BuildingTimerConstruction> = new Map<Int, BuildingTimerConstruction>();
	private static var timerContainer:Container;
	
	public static function initTimerContainer():Void {
		timerContainer = new Container();
		GameStage.getInstance().getGameContainer().addChild(timerContainer);
	}
	
	public static function getTimerContainer():Container {
		return timerContainer;
	}
	
	public static function newTimer():Void {
		var buildingTimer:BuildingTimerConstruction = new BuildingTimerConstruction();
		buildingTimer.spawn();
		listTimerConstruction.set(BuildingHud.virtualBuilding.tileDesc.id, buildingTimer);
		var lContainer:Container = new Container();
		Hud.getInstance().placeAndAddComponent(buildingTimer, lContainer, UIPosition.BOTTOM);
		lContainer.position.x += BuildingHud.virtualBuilding.graphic.getLocalBounds().width / 2;
		timerContainer.addChild(lContainer);
	}
	
	public static function getInstance (): BHConstruction {
		if (instance == null) instance = new BHConstruction();
		return instance;
	}
	
	private function new() {
		super("BuildingContext");	
	}
	
	override public function setOnSpawn():Void {
		setGameListener();
		addListeners();
	}
	
	private function setGameListener():Void {
		GameStage.getInstance().getGameContainer().interactive = true;
		GameStage.getInstance().getGameContainer().on(MouseEventType.MOUSE_UP, onClickExit);
	}
	
	override private function addListeners():Void 
	{
		SmartCheck.traceChildrens(this);
		btnMove = cast(getChildByName("ButtonMoveBuilding"), SmartButton);
		btnDestroy = cast(getChildByName("ButtonCancelConstruction"), SmartButton);
		btnSpeedUp = cast(getChildByName("ButtonAccelerate"), SmartButton);
		
		Interactive.addListenerClick(btnSpeedUp, onSpeedUp);
	}
	
	private function onSpeedUp():Void {
		if (DialogueManager.ftueStepConstructBuilding) {
			DialogueManager.endOfaDialogue();
		}
		
		UIManager.getInstance().closeCurrentPopin();
		SpeedUpPopin.linkBuilding(BuildingHud.virtualBuilding);
		UIManager.getInstance().openPopin(SpeedUpPopin.getInstance());
	}
	
	private function onClickExit(pEvent:EventTarget):Void {
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