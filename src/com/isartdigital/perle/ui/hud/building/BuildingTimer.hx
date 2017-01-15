package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;

/**
 * ...
 * @author grenu
 */
class BuildingTimer extends SmartComponent
{	
	private var progress:SmartComponent;
	private var btnSpeedup:SmartButton;	
	private var timeText:TextSprite;
	private var progressBar:UISprite;

	private var loop:Timer;
	private var building:VBuilding;
	
	public function new() 
	{
		super("BuildingTimer");	
	}
	
	public function spawn():Void {
		loop = Timer.delay(progressTimeLoop, 1000);
		loop.run = progressTimeLoop;
		
		building = BuildingHud.virtualBuilding;
		
		getComponents();
		showTime();
	}
	
	private function progressTimeLoop():Void {
		if (TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isBuilding) {
			timeText.text = TimeManager.getTextTime(building.tileDesc);
			updateProgressBar();
		} else {
			progressBar.scale.x = 1;
			timeText.text = "Finish";
			loop.stop;
		}
	}
	
	private function updateProgressBar():Void {
		progressBar.scale.x = TimeManager.getPourcentage(building.tileDesc.timeDesc);
	}
	
	private function showTime():Void {
		timeText.text = TimeManager.getTextTime(BuildingHud.virtualBuilding.tileDesc);
		
		if (TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isBuilding)
			btnSpeedup.on(MouseEventType.CLICK, onClickSpeedup);
			
		updateProgressBar();
	}
	
	private function onClickSpeedup():Void {
		trace("decrease time contruction: -5s");
		var isFinish:Bool = TimeManager.increaseProgress(building, 5000);
		if (isFinish) {
			timeText.text = "Finish";
			btnSpeedup.off(MouseEventType.CLICK, onClickSpeedup);
		}
		else timeText.text = TimeManager.getTextTime(BuildingHud.virtualBuilding.tileDesc);
		
		updateProgressBar();
	}
	
	private function getComponents():Void {
		progress = cast(getChildByName("Gauge"), SmartComponent);
		timeText = cast(progress.getChildByName("_time"), TextSprite);
		progressBar = cast(progress.getChildByName("_gauge"), UISprite);
		btnSpeedup = cast(getChildByName("Button"), SmartButton);
	}
	
	override public function destroy():Void {
		loop.stop();
		parent.removeChild(this);
		super.destroy();
	}
}