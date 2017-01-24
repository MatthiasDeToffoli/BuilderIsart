package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Alexis
 */
class CarousselCardUnlock extends CarouselCard
{
	
	private var lButton:SmartButton;
	
	private var text_name:TextSprite;
	private var text_price:TextSprite;
	private var text_number_resource:TextSprite;
	
	private var lAssetName:String; // todo @Alexis: suppr et tout ce qui est lié, le switch
	
	override public function new(pID:String=null) {
		super(pID);
		
		
		
		//sfIcon = cast(SmartCheck.getChildByName(this, "SoftCurrency_icon"), UISprite); 
		//lButton = cast(SmartCheck.getChildByName(this, "ButtonBuyBuildingDeco"), SmartButton); 
		
		//image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		//imageCurrency = cast(SmartCheck.getChildByName(this, "Currency_icon"), UISprite);
		
	}
	
	
	
	override public function init (pBuildingName:String):Void {
		lAssetName = BuildingName.getAssetName(pBuildingName); // todo : inutile ?
		super.init(pBuildingName);
		
	}
	
	override function buildCard():Void {
		super.buildCard();
		if (!BuyManager.canBuy(buildingName))
			alpha = 0.5;
			
		
	}
	
	private function setName (pAssetName:String):Void {}
	
	private function setPrice (pInt:Int):Void {
		text_price.text = Std.string(pInt);
	}
	
	override private function _click (pEvent:EventTarget = null):Void {
		if (alpha == 0.5)
			return;
		super._click(pEvent);
		//UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
		//ConfirmBuyBuilding.getInstance().init(buildingAssetName);
		closeShop();
	}
	
	private function closeShop ():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function numberToGive():Int {
		switch(lAssetName) {
			case("Wood pack") : return 1000;
			case("Iron pack") : return 1000;
			case("Gold pack") : return 10000;
			case("Karma pack") : return 100;
		}
		return 0;
	}
	
	override public function destroy():Void {
		//removeListener(MouseEventType.CLICK, onClick);
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}