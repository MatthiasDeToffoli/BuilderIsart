package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.ServerManager.EventSuccessAddBuilding;

/**
 * ...
 * @author ambroise
 */
class RollBackManager{

	public static function deleteBuilding (pEvent:EventSuccessAddBuilding):Void {
		IdManager.searchVBuildingById(pEvent.iDClientBuilding).destroy();
	}
	
}