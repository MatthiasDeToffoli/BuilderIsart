package com.isartdigital.perle.ui.popin.marketing;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.MarketingManager.Campaign;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class TimerCampaign extends SmartComponent
{

	private var timerText:TextSprite;
	
	public function new() 
	{
		super(AssetName.CAMPAIGN_PANEL_TIMER);
		
		var myCampaign:Campaign = MarketingManager.getCurrentCampaign();
		var myClock:Clock = TimesInfo.getClock(myCampaign.time);
		
		var txt:TextSprite = cast(SmartCheck.getChildByName(this, AssetName.CAMPAIGN_TIMER_BOOST_VALUE), TextSprite);
		txt.text = myCampaign.boost + "";
		
		txt = cast(SmartCheck.getChildByName(this, AssetName.CAMPAIGN_TIMER_TIME_VALUE), TextSprite);
		txt.text = "/" + myClock.minute + ":" + myClock.seconde;
		
		var TimeBar:SmartComponent = cast(SmartCheck.getChildByName(this, AssetName.CAMPAIGN_TIMER));
		timerText = cast(SmartCheck.getChildByName(TimeBar, AssetName.TIME_GAUGE_TEXT), TextSprite);
		rewriteTime(myCampaign.time);
		TimeManager.eCampaign.on(TimeManager.EVENT_CAMPAIGN, rewriteTime);
		//SmartCheck.traceChildrens(this);
		
	}
	
	private function rewriteTime(time:Float):Void {
		var myClock:Clock = TimesInfo.getClock(TimesInfo.calculDateDiff(time, Date.now().getTime()));

		timerText.text = myClock.houre + ":" + myClock.minute + ":" + myClock.seconde;
	}
	
	override public function destroy():Void 
	{
		parent.removeChild(this);
		super.destroy();
	}
	
}