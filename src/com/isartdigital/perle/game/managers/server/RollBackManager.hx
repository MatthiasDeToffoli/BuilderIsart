package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding.EventSuccessMoveBuilding;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud;

/**
 * ...
 * @author ambroise
 */
class RollBackManager{

	public static function deleteBuilding (pIDClientBuilding:Int):Void {
		IdManager.searchVBuildingById(pIDClientBuilding).destroy();
	}
	
	public static function deleteIntern(pId:Int):Void {
		Intern.destroyIntern(pId, false);
	}
	
	public static function cancelMoveBuilding (pEvent:EventSuccessMoveBuilding):Void {
		Hud.getInstance().hideBuildingHud();
		var lVBuilding:VBuilding = IdManager.searchVBuildingById(pEvent.iDClientBuilding);
		lVBuilding.desactivate();
		lVBuilding.move({
			regionFirstTile: RegionManager.worldMap[pEvent.oldRegionX][pEvent.oldRegionY].desc.firstTilePos,
			region: {x: pEvent.oldRegionX, y:pEvent.oldRegionY},
			map: {x: pEvent.oldX, y:pEvent.oldY}
		});
	}
}