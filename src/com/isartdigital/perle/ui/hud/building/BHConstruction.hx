package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.accelerate.SpeedUpPopin;
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
	
	public static function initTimer():Void {
		timerContainer = new Container();
		GameStage.getInstance().getGameContainer().addChild(timerContainer);
		
		for (i in 0...TimeManager.listConstruction.length) {
			BuildingHud.linkVirtualBuilding(TimeManager.timeLinkToVBuilding[TimeManager.listConstruction[i].refTile]);
			newTimer(TimeManager.listConstruction[i]);
		}
	}
	
	public static function getTimerContainer():Container {
		return timerContainer;
	}
	
	public static function newTimer(?pTimeDesc:TimeDescription = null):Void {
		var lVBuilding:VBuilding = BuildingHud.virtualBuilding == null ? VTribunal.getInstance():BuildingHud.virtualBuilding;
		var buildingTimer:BuildingTimerConstruction = new BuildingTimerConstruction();
		buildingTimer.spawn();
		if (pTimeDesc != null) listTimerConstruction.set(pTimeDesc.refTile, buildingTimer);
		else listTimerConstruction.set(lVBuilding.tileDesc.id, buildingTimer);
		var lContainer:Container = new Container();	
		Hud.getInstance().placeAndAddComponent(buildingTimer, lContainer, UIPosition.BOTTOM);
		lContainer.position.x += lVBuilding.graphic.getLocalBounds().width / 2;
		timerContainer.addChild(lContainer);
	}
	
	public static function hideTimer(pTimeDesc:TimeDescription):Void {
		//trace("apres la correction des barres");
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
		//SmartCheck.traceChildrens(this);
		btnMove = cast(getChildByName("ButtonMoveBuilding"), SmartButton);
		btnDestroy = cast(getChildByName("ButtonCancelConstruction"), SmartButton);
		btnSpeedUp = cast(getChildByName("ButtonAccelerate"), SmartButton);
		
		Interactive.addListenerClick(btnSpeedUp, onSpeedUp);
	}
	
	public function onSpeedUp():Void {
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