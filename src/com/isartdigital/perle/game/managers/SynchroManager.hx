package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ServerManager.EventSuccessAddBuilding;
import haxe.Json;

/**
 * ...
 * @author ambroise
 */
class SynchroManager{

	public static function syncTimeOfBuilding (pEvent:EventSuccessAddBuilding):Void {
		// todo : @vicktor : à faire vérifier par Vicktor qui s'occupe du temps.
		trace("Synchronisation time building :" + Json.stringify(pEvent));
		RegionManager.worldMap[pEvent.regionX][pEvent.regionY].building[pEvent.x][pEvent.y].tileDesc.timeDesc.creationDate = pEvent.startConstruction;
		RegionManager.worldMap[pEvent.regionX][pEvent.regionY].building[pEvent.x][pEvent.y].tileDesc.timeDesc.end = pEvent.endConstruction - pEvent.startConstruction;
	}
	
}