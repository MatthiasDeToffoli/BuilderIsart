package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Tile;
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
import haxe.Timer;
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
	
	public static function getInstance (): BHConstruction {
		if (instance == null) instance = new BHConstruction();
		return instance;
	}
	
	private function new() {
		super("BuildingContext");
	}
	
	override public function setOnSpawn():Void {
		Timer.delay(setGameListener,500);
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
		
		if (DialogueManager.ftueStepPutBuilding || DialogueManager.ftueStepConstructBuilding) {
			btnMove.interactive = false;
			btnDestroy.interactive = false;
			btnMove.alpha = 0.2;
			btnDestroy.alpha = 0.2;
		}
		else {
			btnMove.interactive = true;
			btnDestroy.interactive = true;
			btnMove.alpha = 1;
			btnDestroy.alpha = 1;
			
		}
		
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