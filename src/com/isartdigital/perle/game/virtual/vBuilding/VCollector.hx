package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
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
class VCollector extends VBuildingUpgrade
{
	public var myPacks(default, null):Array<ProductionPack>;
	public var timeProd:TimeCollectorProduction;
	public var product:Bool = false;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, updateMyTime);
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION_STOP, stopProduction);
	}
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}
	
	public function updateMyTime(pTime:TimeCollectorProduction):Void{
		
		if (pTime.buildingRef == tileDesc.id)
			timeProd = pTime;
			
	}
	
	private function stopProduction(pRef:Int):Void {
		if (pRef != tileDesc.id) return;
		
		timeProd = null;
		product = false;
	}
	
	public function startProduction(pack:ProductionPack):Void{
		timeProd = TimeManager.createProductionTime(pack, tileDesc.id);
		product = true;
		ResourcesManager.spendTotal(GeneratorType.soft, pack.cost);
	}
	
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, updateMyTime);
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION_STOP, stopProduction);
		super.destroy();
	}
	
}