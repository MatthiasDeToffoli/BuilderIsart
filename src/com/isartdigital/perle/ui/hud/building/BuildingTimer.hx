package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.utils.Interactive;
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
	private var timeText:TextSprite;
	private var progressBar:UISprite;
	private var progressBarWidth:Float;

	private var loop:Timer;
	private var building:VBuilding;
	
	public function new() 
	{
		super("BuildingTimer");	
	}
	
	public function spawn(?pRef:Int):Void {
		if (pRef == null) building = BuildingHud.virtualBuilding == null ? VTribunal.getInstance():BuildingHud.virtualBuilding;
		else building = IdManager.searchVBuildingById(pRef);
		getComponents();
		showTime(building.tileDesc);
	}
	
	
	private function updateProgressBar():Void {
		
	}
	
	private function showTime(?pTileDesc:TileDescription):Void {

	}
	
	private function getComponents():Void {
		progress = cast(getChildByName("Gauge"), SmartComponent);
		timeText = cast(progress.getChildByName("_time"), TextSprite);
		progressBar = cast(progress.getChildByName("_gauge"), UISprite);
		progressBarWidth = progressBar.width;
	}
	
	override public function destroy():Void {	
		if(parent != null) parent.removeChild(this);
		super.destroy();
	}
}