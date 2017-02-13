package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BuildingTimerCollector extends BuildingTimer
{

	private var ref:Int;
	
	public function new() 
	{
		ref = BuildingHud.virtualBuilding.tileDesc.id;
		super();
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, showTime);
	}
	
	override function showTime(?pTime:Dynamic):Void 
	{
		
		if (pTime == null) pTime = cast(BuildingHud.virtualBuilding, VCollector).timeProd;
		if (pTime.refTile != ref) return;
		var clock:Clock = TimesInfo.getClock(TimesInfo.calculDateDiff(pTime.end, pTime.progress));

		timeText.text = clock.day + ":" + clock.hour + ":" + clock.minute + ":" + clock.seconde;
	}
	
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, showTime);
		super.destroy();
	}
	
}