package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import haxe.Timer;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BuildingTimerConstruction extends BuildingTimer
{

	public function new() 
	{
		super();
		
	}
	
	override public function spawn():Void 
	{
		loop = Timer.delay(progressTimeLoop, 100);
		loop.run = progressTimeLoop;
		super.spawn();
	}
	
	override private function updateProgressBar():Void {
		progressBar.scale.x = TimeManager.getPourcentage(building.tileDesc.timeDesc);
	}
	
	override private function showTime(?pTime:Dynamic):Void {
		timeText.text = TimeManager.getTextTime(BuildingHud.virtualBuilding.tileDesc);		
		updateProgressBar();
	}
	
	public function boost(pValue:Float):Void {
		var isFinish:Bool = TimeManager.increaseProgress(building, pValue);
		if (isFinish) {
			if (DialogueManager.ftueStepConstructBuilding) {
				trace("Je passe la prochaine etape de FTUe, je le met en trace comme ça tout le monde le vois : Il faut rajouter la poppin skip timer pour que je puisse mettre la prochaine etape  bisous Alexis");
				DialogueManager.endOfaDialogue();
			}
			timeText.text = "Finish";
			BHConstruction.listTimerConstruction.remove(building.tileDesc.id);
			destroy();
		}
		else timeText.text = TimeManager.getTextTime(BuildingHud.virtualBuilding.tileDesc);
		
		ServerManager.ContructionTimeAction(BuildingHud.virtualBuilding.tileDesc.timeDesc, DbAction.UPDT);
		updateProgressBar();
	}
	
	private function progressTimeLoop():Void {
		if (TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isBuilding || TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isUpgrading) {
			timeText.text = TimeManager.getTextTime(building.tileDesc);
			updateProgressBar();
		} else {
			progressBar.scale.x = 1;
			timeText.text = "Finish";
			loop.stop;
		}
	}
	
	override public function destroy():Void 
	{
		loop.stop();
		super.destroy();
	}
}