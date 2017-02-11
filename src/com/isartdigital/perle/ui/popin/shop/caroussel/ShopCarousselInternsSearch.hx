package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;

/**
 * ...
 * @author Emeline Berenguier
 */
class ShopCarousselInternsSearch extends ShopCaroussel{

	private var gauge:SmartComponent;
	private var gaugeTimer:TextSprite;
	private var gaugeBar:UISprite;
	private var accelerateButton:SmartButton; //@Todo: faire le lien avec la classe AccelerateBtn
	
	private var loop:Timer;
	public static var progress:Float; //A enlever
	
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN_SEARCHING);
		
		getComponents();
		addListeners();
		setValues();
		spawn();
	}
	
	private function getComponents():Void{
		accelerateButton =cast(SmartCheck.getChildByName(this, AssetName.REROLL_ACCELERATE_BUTTON), SmartButton);
		gauge = cast(SmartCheck.getChildByName(this, AssetName.REROLL_GAUGE), SmartComponent);
		gaugeBar = cast(SmartCheck.getChildByName(gauge, AssetName.REROLL_GAUGE_BAR), UISprite);
		gaugeTimer = cast(SmartCheck.getChildByName(gauge, AssetName.REROLL_GAUGE_TEXT), TextSprite);
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(accelerateButton, onAccelerate);
	}
	
	private function setValues():Void{
		gaugeBar.scale.x = 0;
	}
	
	private function spawn():Void{
		loop = Timer.delay(progressTimeLoop, 100);
		loop.run = progressTimeLoop;
	}
	
	private function progressTimeLoop():Void {
		if (gaugeBar.scale.x != 1) {
			progress+= 1000;
			gaugeTimer.text = TimeManager.getTextTimeReroll(10000 - progress);
			updateProgressBar();
		} else {
			progress = 0;
			ShopCarousselInterns.changeID();
			ShopPopin.isSearching = false;
			
			UIManager.getInstance().closeCurrentPopin();
			ShopPopin.getInstance().init(ShopTab.Interns);
			UIManager.getInstance().openPopin(ShopPopin.getInstance());
			loop.stop();
		}
	}
	
	private function updateProgressBar():Void{
		gaugeBar.scale.x = Math.min(TimeManager.getTimePourcentage(progress, 10000), 1);
	}
	
	/** 
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void { }

	//override private function getSpawnersAssetNames():Array<String> {
		//return [ // todo : constantes ? c'est des spawners..
			//"Intern_?_1",
			//"Intern_?_2",
			//"Intern_?_3"
		//];
	//}
	
	private function onAccelerate():Void{
		trace("accelerate");
	}
	
	override public function destroy():Void{
		Interactive.removeListenerClick(accelerateButton, onAccelerate);
	}
	
}