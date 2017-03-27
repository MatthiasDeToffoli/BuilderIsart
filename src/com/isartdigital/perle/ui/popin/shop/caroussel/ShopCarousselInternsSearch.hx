package com.isartdigital.perle.ui.popin.shop.caroussel;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;

/**
 * Popin for the search of interns
 * @author Emeline Berenguier
 */
class ShopCarousselInternsSearch extends ShopCaroussel{

	private var gauge:SmartComponent;
	private var gaugeTimer:TextSprite;
	private var gaugeBar:UISprite;
	private var gaugeMask:UISprite;
	private var accelerateButton:SmartButton;
	private var searchText:TextSprite;
	private var searchCost:TextSprite;
	
	private var loop:Timer;
	public static var progress:Float; 
	
	private static inline var SKIP_PRICE:Int = 5;
	private static inline var PROGRESS_VALUE:Int = 100;
	private static inline var PROGRESS_TOTAL:Int = 1800000;
	
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN_SEARCHING);
		
		getComponents();
		addListeners();
		setValues();
		spawn();
	}
	
	private function getComponents():Void{
		accelerateButton = cast(SmartCheck.getChildByName(this, AssetName.REROLL_ACCELERATE_BUTTON), SmartButton);
		searchText = cast(SmartCheck.getChildByName(this, AssetName.REROLL_GAUGE_TITLE), TextSprite);
		
		gauge = cast(SmartCheck.getChildByName(this, AssetName.REROLL_GAUGE), SmartComponent);
		gaugeBar = cast(SmartCheck.getChildByName(gauge, AssetName.REROLL_GAUGE_BAR), UISprite);
		gaugeTimer = cast(SmartCheck.getChildByName(gauge, AssetName.REROLL_GAUGE_TEXT), TextSprite);
		gaugeMask = cast(SmartCheck.getChildByName(gauge, AssetName.REROLL_GAUGE_MASK), UISprite);
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(accelerateButton, onAccelerate);
	}
	
	private function setValues():Void{
		gaugeMask.scale.x = 0;
		gaugeBar.scale.x = 0;
		
		searchText.text = Localisation.getText("LABEL_SHOPINTERN_SEARCHINGFORINTERNS");
		searchCost = cast(SmartCheck.getChildByName(accelerateButton, "_accelerate_cost"), TextSprite);
		searchCost.text = SKIP_PRICE + "";
		
		Interactive.addListenerRewrite(accelerateButton, rewritePrice);
	}
	
	private function rewritePrice():Void {
		searchCost = cast(SmartCheck.getChildByName(accelerateButton, "_accelerate_cost"), TextSprite);
		searchCost.text = SKIP_PRICE + "";
	}
	
	private function spawn():Void{
		loop = Timer.delay(progressTimeLoop, 100);
		loop.run = progressTimeLoop;
	}
	
	private function progressTimeLoop():Void {
		if (gaugeBar.scale.x != 1) {
			progress+= PROGRESS_VALUE;
			gaugeTimer.text = TimeManager.getTextTimeReroll(PROGRESS_TOTAL - progress);
			updateProgressBar();
		} else {
			end();
		}
	}
	
	private function updateProgressBar():Void{
		gaugeBar.scale.x = Math.min(TimeManager.getTimePourcentage(progress, PROGRESS_TOTAL), 1);
	}
	
	/**
	 * Finish the search and go to the shop
	 */
	private function end():Void{
		progress = 0;
		ShopPopin.isSearching = false;
			
		UIManager.getInstance().closeCurrentPopin();
		ShopPopin.getInstance().init(ShopTab.Interns);
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		loop.stop();
	}
	
	/** 
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void { 
		return null;
	}
	
	private function onAccelerate():Void{
		if (SKIP_PRICE <= ResourcesManager.getTotalForType(GeneratorType.hard)){
			ResourcesManager.spendTotal(GeneratorType.hard, SKIP_PRICE);
			SoundManager.getSound("SOUND_KARMA").play();
			end();
		}
	}
	
	override public function destroy():Void{
		Interactive.removeListenerClick(accelerateButton, onAccelerate);
		Interactive.removeListenerRewrite(searchText, rewritePrice);
	}
	
}