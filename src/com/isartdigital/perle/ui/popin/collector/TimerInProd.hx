package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.managers.SaveManager.TimeCollectorProduction;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VCollectorHeaven;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class TimerInProd extends SmartComponent
{
	
	private var progressBarTxt:TextSprite;
	private var gain:TextSprite;

	public function new(collector:VCollector) 
	{
		super(AssetName.COLLECTOR_TIME_IN_PROD);
		
		SmartCheck.traceChildrens(this);
		var progressBar:SmartComponent = cast(SmartCheck.getChildByName(this, AssetName.COLLECTOR_TIME_GAUGE), SmartComponent);
		
		progressBarTxt = cast(SmartCheck.getChildByName(progressBar, AssetName.COLLECTOR_TIME_GAUGE_TEXT), TextSprite);
		
		rewrite(collector.timeProd);
		
		gain = cast(SmartCheck.getChildByName(this, AssetName.COLLECTOR_TIME_GAIN));
		gain.text = collector.timeProd.gain +"";
		
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, AssetName.COLLECTOR_TIME_ICON));
		var icone:UISprite = new UISprite(Std.is(collector, VCollectorHeaven) ? AssetName.PROD_ICON_WOOD_LARGE:AssetName.PROD_ICON_STONE_LARGE);
		
		icone.position = spawner.position;
		
		addChild(icone);
		
		spawner.parent.removeChild(spawner);
		
		
		
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, rewrite);
		
	}
	
	private function rewrite(pTime:TimeCollectorProduction ){
		var clock:Clock = TimesInfo.getClock(pTime.progress);
		
		progressBarTxt.text = clock.minute + ":" + clock.seconde;
	}
	
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, rewrite);
		super.destroy();
	}
	
}