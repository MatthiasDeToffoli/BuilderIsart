package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.sounds.SoundManager;
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
		super.spawn();
		
		loop = Timer.delay(progressTimeLoop, 100);
		loop.run = progressTimeLoop;
		
		if (DialogueManager.boostBuilding)
			boost();
	}
	
	override private function updateProgressBar():Void {
		progressBar.scale.x = TimeManager.getPourcentage(building.tileDesc);
	}
	
	override private function showTime(?pTileDesc:TileDescription):Void {
		timeText.text = TimeManager.getTextTime(pTileDesc);	
	}
	
	public function boost():Void {
		TimeManager.increaseConstruction(building);
		BHConstruction.listTimerConstruction.remove(building.tileDesc.id);
		building.alignementBuilding == Alignment.heaven ? SoundManager.getSound("SOUND_FINISH_BUILDING_HEAVEN").play() : SoundManager.getSound("SOUND_FINISH_BUILDING_HELL").play();
		
		if(DialogueManager.passFree)
			DialogueManager.endOfaDialogue();
	}
	
	private function progressTimeLoop():Void {
		if (TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isBuilding || TimeManager.getBuildingStateFromTime(building.tileDesc) == VBuildingState.isUpgrading) {
			timeText.text = TimeManager.getTextTime(building.tileDesc);
			updateProgressBar();
		} else {
			if (DialogueManager.ftuePlayerCanWait) {
				DialogueManager.dialogueSaved += 1;
				DialogueManager.endOfaDialogue();
			}
			progressBar.scale.x = 1;
			timeText.text = "Finish";
			var arrayForChange:Map<String, Dynamic> = ["type" => BuildingHudType.HARVEST, "building" => building];
			Hud.eChangeBH.emit(Hud.EVENT_CHANGE_BUIDINGHUD, arrayForChange);
			BHConstruction.listTimerConstruction.remove(building.tileDesc.id);
			destroy();
		}
	}
	
	override public function destroy():Void 
	{
		loop.stop();
		super.destroy();
	}
}