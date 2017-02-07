package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.popin.collector.CollectorPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltCollector extends BHBuiltProductor
{

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override function testIfProduct():Bool 
	{
		return cast(BuildingHud.virtualBuilding, VCollector).product;
	}
	override function createTimer():Void 
	{
		timer = new BuildingTimerCollector();
		timer.spawn();
		Hud.getInstance().addSecondaryComponent(timer);
	}
	
	override function openInfoBuilding():Void 
	{
		UIManager.getInstance().openPopin(CollectorPopin.getInstance());
		Hud.getInstance().hide();
	}
	
}