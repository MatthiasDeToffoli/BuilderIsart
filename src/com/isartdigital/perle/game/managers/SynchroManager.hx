package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessAddBuilding;
import haxe.Json;

/**
 * ...
 * @author ambroise
 */
class SynchroManager{

	public static function syncTimeOfBuilding (pEvent:EventSuccessAddBuilding):Void {
		// todo : @victor : à faire vérifier par Vicktor qui s'occupe du temps.
		//trace("Synchronisation time building :" + Json.stringify(pEvent));
		
		IdManager.searchVBuildingById(pEvent.iDClientBuilding).tileDesc.timeDesc.creationDate = pEvent.startConstruction;
		IdManager.searchVBuildingById(pEvent.iDClientBuilding).tileDesc.timeDesc.end = pEvent.endConstruction;
	}
	
}