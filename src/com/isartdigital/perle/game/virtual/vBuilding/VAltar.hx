package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.BoostManager;
import com.isartdigital.perle.game.managers.BuildingLimitManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VAltar extends VBuilding
{

	private var alignmentEffect:Alignment;
	private var nbHeaven:Int;
	private var nbHell:Int;
	private static inline var ZONESIZE:Int = 4;
	private var heavenBonus:Float;
	private var hellBonus:Float;
	
	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.neutral;
		super(pDescription);
		
		var typeBuilding:TableTypeBuilding = GameConfig.getBuildingByName(tileDesc.buildingName);
		heavenBonus = typeBuilding.productionPerBuildingHeaven;
		hellBonus = typeBuilding.productionPerBuildingHell;

		nbHeaven = 0;
		nbHell = 0;
		BoostManager.boostBuildingEvent.on(BoostManager.BUILDING_ON_EVENT_NAME, onBuildingToAdd);
		BoostManager.boostBuildingEvent.on(BoostManager.BUILDING_OFF_EVENT_NAME, onBuildingToRemove);
		checkInZone();
	}
	
	/**
	 * check if a building is in it zone
	 */
	private function checkInZone(){
		checkInZoneByAlignment(Alignment.heaven);
		checkInZoneByAlignment(Alignment.hell);
	}
	
	/**
	 * check if a building is in it zone in hell region or heaven region
	 * @param	pType the type of region we want to check
	 */
	private function checkInZoneByAlignment(pType:Alignment):Void {
		var i:Int, j:Int;
		
		var regionPos:Index = pType == Alignment.heaven ? {x:tileDesc.regionX - 1, y:tileDesc.regionY}:{x:tileDesc.regionX + 1, y:tileDesc.regionY};
		var posX:Int;
		
		for (i in 0...VAltar.ZONESIZE){
			for (j in 0...(VAltar.ZONESIZE - i)) {
				posX = pType == Alignment.heaven ? Ground.COL_X_LENGTH - 1 - i:i;
				
				if(tileDesc.mapY - j < 0) BoostManager.altarCheckIfHasBuilding({x:regionPos.x, y:regionPos.y - 1}, {x:posX, y:Ground.ROW_Y_LENGTH +tileDesc.mapY + 1 - j});
				else BoostManager.altarCheckIfHasBuilding(regionPos, {x:posX, y:tileDesc.mapY - j});
				
				if(tileDesc.mapY + j + 1 > Ground.ROW_Y_LENGTH) BoostManager.altarCheckIfHasBuilding({x:regionPos.x, y:regionPos.y + 1}, {x:posX, y:tileDesc.mapY + j - (Ground.ROW_Y_LENGTH)});
				else BoostManager.altarCheckIfHasBuilding(regionPos, {x:posX, y:tileDesc.mapY + 1 + j});
			}
		}
	}
	
	public function updateNbHellAndHeaven(pNbHell:Int, pNbHeaven:Int):Void {
		nbHell = pNbHell;
		nbHeaven = pNbHeaven;
	}
	
	/**
	 * add a building ref to his array
	 * @param	pData contain all building information altar need
	 */
	private function onBuildingToAdd(pData:BoostInfo):Void {
		if (pData.regionPos.y > tileDesc.regionY + 1 || pData.regionPos.y < tileDesc.regionY - 1) return;
		
		var i:Int, j:Int;
		
		var regionPos:Index = pData.type == Alignment.heaven ? {x:tileDesc.regionX - 1, y:tileDesc.regionY}:{x:tileDesc.regionX + 1, y:tileDesc.regionY};
		var posX:Int;

		for (i in 0...VAltar.ZONESIZE){
			for (j in 0...(VAltar.ZONESIZE - i)) {
				posX = pData.type == Alignment.heaven ? Ground.COL_X_LENGTH - 1 - i:i;
				
				if (pData.casePos.x == posX && (pData.casePos.y == Ground.ROW_Y_LENGTH +tileDesc.mapY + 1 - j || pData.casePos.y == tileDesc.mapY - j)){
					if (pData.type == Alignment.hell) nbHell++;
					else if (pData.type == Alignment.heaven) nbHeaven++;
					
					ServerManagerBuilding.checkForIncreaseAltarNbBuilding(tileDesc);
					return;
				}
				
				
				if (pData.casePos.x == posX && (pData.casePos.y == tileDesc.mapY + j - (Ground.ROW_Y_LENGTH) || pData.casePos.y == tileDesc.mapY + 1 + j)){
					ServerManagerBuilding.checkForIncreaseAltarNbBuilding(tileDesc);
					
					if (pData.type == Alignment.hell) nbHell++;
					else if (pData.type == Alignment.heaven) nbHeaven++;
					
					return;
				}
			
			}
		}
	}
	

	
	private function onBuildingToRemove(?pData:BoostInfo):Void {
		if (pData != null && (pData.regionPos.y > tileDesc.regionY + 1 || pData.regionPos.y < tileDesc.regionY - 1)) return;
		ServerManagerBuilding.checkForIncreaseAltarNbBuilding(tileDesc);
		
		if (pData != null) {
			if (pData.type == Alignment.hell) nbHell = Std.int(Math.max(nbHell-1,0));
			else if (pData.type == Alignment.heaven) nbHeaven = Std.int(Math.max(nbHeaven-1,0));
		}
	}
	
	
	override function incrementNumberBuilding():Void 
	{
		BuildingLimitManager.incrementMapNumbersBuilding(tileDesc.buildingName);
	}
	
	private function calculTime():Void{
		var lTime:Float = calculTimeProd();
		myTime = lTime <= 0 ? null:lTime;
	}
	
	override function calculTimeProd(?pTypeBuilding:TableTypeBuilding):Float 
	{
		if (nbHeaven == 0 && nbHell == 0) return null;
 		else return TimesInfo.HOU / (nbHeaven * heavenBonus + nbHell * hellBonus);
	}
	private function haveMoreBoost():Void{

		calculTime();

		ResourcesManager.UpdateResourcesGenerator(myGenerator, myMaxContains, myTime,false);
	}
	
	override public function destroy():Void 
	{
		BoostManager.boostBuildingEvent.off(BoostManager.BUILDING_ON_EVENT_NAME, onBuildingToAdd);
		super.destroy();
	}
	
}