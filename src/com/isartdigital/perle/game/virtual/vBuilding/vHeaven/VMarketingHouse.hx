package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VMarketingHouse extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.heaven;
		super(pDescription);
		MarketingManager.increaseNumberAdMen();
		
	}
	
	override function endOfConstruction(pElement:TimeDescription):Void 
	{
		super.endOfConstruction(pElement);
		ServerManagerBuilding.checkNumberMarketingHouse();
	}
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}
	
	override public function destroy():Void 
	{
		//MarketingManager.decreaseNumberAdMen();
		super.destroy();
	}
	
}