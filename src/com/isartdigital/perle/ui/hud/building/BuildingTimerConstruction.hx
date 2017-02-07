package com.isartdigital.perle.ui.hud.building;

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
		loop = Timer.delay(progressTimeLoop, 1000);
		loop.run = progressTimeLoop;
		super.spawn();
	}
	
	override private function updateProgressBar():Void {
		progressBar.scale.x = TimeManager.getPourcentage(building.tileDesc.timeDesc);
		progressBar.position.x = -progressBarWidth / 2 + progressBar.width / 2;
	}
	
	override private function showTime():Void {
		timeText.text = TimeManager.getTextTime(BuildingHud.virtualBuilding.tileDesc);		
		updateProgressBar();
	}
	
	override private function onClickSpeedup():Void {
		trace("decrease time contruction: -5s");
		var isFinish:Bool = TimeManager.increaseProgress(building, 20000);
		if (isFinish) {
			if (DialogueManager.ftueStepConstructBuilding) {
				trace("Je passe la prochaine etape de FTUe, je le met en trace comme ça tout le monde le vois : Il faut rajouter la poppin skip timer pour que je puisse mettre la prochaine etape  bisous Alexis");
				DialogueManager.endOfaDialogue();
			}
			timeText.text = "Finish";
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