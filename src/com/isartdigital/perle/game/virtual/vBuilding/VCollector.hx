package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypePack;
import com.isartdigital.perle.game.TimesInfo.TimesAndNumberDays;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;

 typedef ProductionPack =  {
	 var cost:Int;
	 var time:TimesAndNumberDays;
	 var quantity:Int;
 }
 
/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollector extends VBuildingUpgrade
{
	public var myPacks(default, null):Array<ProductionPack>;
	public var timeProd:TimeDescription;
	public var product:Bool;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		setProductInStart();
		var i:Int;
		var lArray:Array<TableTypePack> = GameConfig.getBuildingPack(myGeneratorType);
		myPacks = new Array<ProductionPack>();
		var lPack:ProductionPack;
		
		
		for (i in 0...lArray.length) {
			var diff:TimesAndNumberDays = TimesInfo.calculDateDiff(Date.fromString(lArray[i].time).getTime(), Date.fromTime(0).getTime());
			lPack = {
				cost:lArray[i].costGold,
				quantity: myGeneratorType == GeneratorType.buildResourceFromHell ? lArray[i].gainIron:lArray[i].gainWood,
				time: {
					times: TimesInfo.getTimeInMilliSecondFromTimeStamp(diff.times),
					days:diff.days
				}
			}
			//lPack.time = TimesInfo.calculDateDiff(lPack.time, Date.fromTime(0).getTime());
			myPacks.push(lPack);
		}

		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, updateMyTime);
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION_STOP, stopProduction);
	}
	
	private function setProductInStart():Void {
		
		for (ltimeDesc in TimeManager.listProduction) {
			if (ltimeDesc.refTile == tileDesc.id) {
				timeProd = ltimeDesc;
				product = true;
				return;
			}
		}
		
		product = false;
	}
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}
	
	public function updateMyTime(pTime:TimeDescription):Void{
		
		if (pTime.refTile == tileDesc.id)
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