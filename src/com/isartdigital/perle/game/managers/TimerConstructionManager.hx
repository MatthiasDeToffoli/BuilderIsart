package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.building.BuildingTimerConstruction;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * gestion of times construction graphic
 * @author Grenu Victor de Toffoli Matthias
 */
class TimerConstructionManager
{

	public static var listTimerConstruction:Map<Int, BuildingTimerConstruction> = new Map<Int, BuildingTimerConstruction>();
	private static var timerContainer:Container;
	
	public static function initTimer():Void {
		timerContainer = new Container();
		GameStage.getInstance().getGameContainer().addChild(timerContainer);

		for (i in 0...TimeManager.listConstruction.length) {
			//BuildingHud.linkVirtualBuilding(TimeManager.timeLinkToVBuilding[TimeManager.listConstruction[i].refTile]);
			newTimer(TimeManager.listConstruction[i].refTile);
		}
	}
	
	/**
	 * TODO : cette function occasionne des bugs régulier, c'est fait à l'arrache et ne devrait PAS se baser sur BuildingHud.virtualBuilding.
	 * @param	pRef reference to the building link at timer
	 */
	public static function newTimer(pRef:Int):Void {
		
		var buildingTimer:BuildingTimerConstruction = new BuildingTimerConstruction();
		buildingTimer.spawn(pRef);
		if (pRef != null) listTimerConstruction.set(pRef, buildingTimer);
		else Debug.error('ref not set on function newTimer in TImerConstructionManager');
		
		placeAndAddTimer(buildingTimer, pRef);
		
		
	}
	
	public static function placeAndAddTimer(pTimer:BuildingTimerConstruction, pRef:Int):Void {

		var lContainer:Container = new Container();
		var lVBuilding:VBuilding = IdManager.searchVBuildingById(pRef);
		var lLocalBounds:Rectangle = lVBuilding.getGraphicLocalBoundsAtFirstFrame().clone();

		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
			
		var lRect:Point = lVBuilding.graphic.position.clone();
		lContainer.position.x = lRect.x + lAnchor.x;
		lContainer.position.y = lRect.y + lAnchor.y;

		
		lContainer.position.y += lLocalBounds.height;
		lContainer.position.x += lVBuilding.getGraphicLocalBoundsAtFirstFrame().clone().width / 2;
		lContainer.addChild(pTimer);
	
		timerContainer.addChild(lContainer);
	}
	
	public static function hideTimer(pRef:Int):Void {
		//trace("apres la correction des barres");
	}
	
	public static function getTimerContainer():Container {
		return timerContainer;
	}
	
}