package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeCollectorProduction;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;

 typedef ProductionPack =  {
	 var cost:Int;
	 var time:Int;
	 var quantity:Int;
 }
 
/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollector extends VBuilding
{
	public var myPacks(default, null):Array<ProductionPack>;
	public var timeProd:TimeCollectorProduction;
	public var product:Bool = false;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, updateMyTime);
	}
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}
	
	override function addGenerator():Void 
	{
		
	}
	
	public function updateMyTime(pTime:TimeCollectorProduction):Void{
		
		if (pTime.buildingRef == tileDesc.id)
			timeProd = pTime;
			
	}
	
	public function startProduction(pack:ProductionPack){
		timeProd = TimeManager.createProductionTime(pack, tileDesc.id);
		product = true;
	}
	
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, updateMyTime);
		super.destroy();
	}
	
}