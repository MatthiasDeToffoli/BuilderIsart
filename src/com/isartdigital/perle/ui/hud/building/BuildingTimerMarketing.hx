package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.TimeManager;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BuildingTimerMarketing extends BuildingTimer
{

	public function new() 
	{
		super();
		TimeManager.eCampaign.on(TimeManager.EVENT_CAMPAIGN, showTime);
	}
	
	override private function showTime(?pTime:Dynamic):Void 
	{
		if (pTime == null) pTime = MarketingManager.getCurrentCampaign().time;
		var myClock:Clock = TimesInfo.getClock(TimesInfo.calculDateDiff(pTime, Date.now().getTime()));		
		timeText.text = myClock.day + ":" + myClock.hour + ":" + myClock.minute + ":" + myClock.seconde;
	}
	
}