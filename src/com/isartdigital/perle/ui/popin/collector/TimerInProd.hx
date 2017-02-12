package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VCollectorHeaven;
import com.isartdigital.perle.ui.popin.accelerate.AcceleratePopinCollector;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
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
	private var accelerateBtn:SmartButton;
	private var ref:Int;
	private var price:Int = 9999999;

	public function new(collector:VCollector) 
	{
		super(AssetName.COLLECTOR_TIME_IN_PROD);
		ref = collector.tileDesc.id;
		accelerateBtn = cast(SmartCheck.getChildByName(this, AssetName.COLLECTOR_TIME_ACCELERATE_BUTTON));
		Interactive.addListenerClick(accelerateBtn, onAccelerate);
		Interactive.addListenerRewrite(accelerateBtn, rewriteBtn);
		rewriteBtn();
		var progressBar:SmartComponent = cast(SmartCheck.getChildByName(this, AssetName.COLLECTOR_TIME_GAUGE), SmartComponent);
		
		progressBarTxt = cast(SmartCheck.getChildByName(progressBar, AssetName.TIME_GAUGE_TEXT), TextSprite);
		
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
	
	private function rewriteBtn():Void {
		var txt:TextSprite = cast(accelerateBtn.getChildByName(AssetName.TIME_ACCELERATE_BUTTON_TXT), TextSprite);
		txt.text = price + "";
	}
	
	private function rewrite(pTime:TimeDescription ){
		
		if (pTime.refTile != ref) return;
		
		var diff:TimesAndNumberDays = TimesInfo.calculDateDiff(pTime.end, pTime.progress);
		
		var clock:Clock = TimesInfo.getClock(diff);
		
		progressBarTxt.text = clock.day + ":" + clock.hour + ":" + clock.minute + ":" + clock.seconde;
		
		price = Math.floor((TimesInfo.getMinute(diff) / 10)+1);
		if(accelerateBtn != null) rewriteBtn();

		if (TimesInfo.timeIsFine(diff)) destroyAccelBtn();
	}
	
	
	private function onAccelerate():Void{
		UIManager.getInstance().openPopin(AcceleratePopinCollector.getInstance());
		rewriteBtn();
	}
	
	public function getPrice():Int {
		return price;
	}
	
	public function getBarText():String {
		return progressBarTxt.text;
	}
	
	public function getRef():Int {
		return ref;
	}
	
	private function destroyAccelBtn():Void {
		
		if (accelerateBtn == null) return;
		
		Interactive.removeListenerClick(accelerateBtn, onAccelerate);
		Interactive.removeListenerRewrite(accelerateBtn, rewriteBtn);
		accelerateBtn.parent.removeChild(accelerateBtn);
		accelerateBtn.destroy();
		accelerateBtn = null;
	}
	
	override public function destroy():Void 
	{
		destroyAccelBtn();
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, rewrite);
		super.destroy();
	}
	
}