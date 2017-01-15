package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
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
	private var imageCurrency:UISprite;
	private var text_name:TextSprite;
	private var numberRessource:TextSprite;
	private var text_price:TextSprite;
	private var sfIcon:UISprite;
	private var lAssetName:String;
	
	override public function new() 
	{
		
		if (ShopCaroussel.lTab != "Building") {
			super(AssetName.CAROUSSEL_CARD_BUNDLE);
			//todo : ces 2 var sont inverser  prevenir GD
			numberRessource = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_PACK_PRICE), TextSprite);
			text_price = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_PACK_CONTENT), TextSprite);
		}
		else {
			
			super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
			image = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PICTURE), UISprite);
			text_name = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_NAME), TextSprite);
			text_price = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PRICE), TextSprite);
		}
			
		//sfIcon = cast(SmartCheck.getChildByName(this, "SoftCurrency_icon"), UISprite); 
		//lButton = cast(SmartCheck.getChildByName(this, "ButtonBuyBuildingDeco"), SmartButton); 
		
		//image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		//imageCurrency = cast(SmartCheck.getChildByName(this, "Currency_icon"), UISprite);
		
	}
	
	
	
	override public function init (pBuildingAssetName:String):Void {
		super.init(pBuildingAssetName);
		lAssetName = pBuildingAssetName;
		// image = pBuildingAssetName ....
		// text idem voir buyManager ?
		setName(buildingAssetName);
		
		//sfIcon = ShopPopin.iconSoft;
		/*var lIconCurrencie:FlumpStateGraphic = new FlumpStateGraphic("_goldIcon_Medium"); // todo :pooling à penser
		lIconCurrencie.init();
		lIconCurrencie.width = 250;
		lIconCurrencie.height = 250;
		sfIcon.addChild(lIconCurrencie);
		lIconCurrencie.start();*/
		
		if (!BuyManager.canBuy(pBuildingAssetName))
			alpha = 0.5;
		setPrice(BuyManager.checkPrice(pBuildingAssetName)); // todo: bon item price par rapprt au json
	}
	
	override public function start ():Void {
		super.start();
		/*interactive = true;
		on(MouseEventType.CLICK, onClick);*/
	}
	
	private function setName (pAssetName:String):Void {
		if (ShopCaroussel.lTab != "Building")
			numberRessource.text = "" + numberToGive();
		else
			text_name.text = FakeTraduction.assetNameNameToTrad(pAssetName);
	}
	
	private function setPrice (pInt:Int):Void {
		text_price.text = Std.string(pInt);
	}
	
	override private function _click (pEvent:EventTarget = null):Void {
		if (alpha == 0.5)
			return;
		super._click(pEvent);
		//UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
		//ConfirmBuyBuilding.getInstance().init(buildingAssetName);
		
		//todo : j ai codé en dur par manque de temps
		switch(ShopCaroussel.lTab) {
			case "Building" : {
				if (BuyManager.canBuy(buildingAssetName)) {
					Phantom.onClickShop(buildingAssetName);
					Hud.getInstance().hideBuildingHud();
					Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
				}
			}
			case "Resource": {
				switch(lAssetName) {
					case("Wood pack") : ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, 1000);
					case("Iron pack") : ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, 1000);
					case("Gold pack") : ResourcesManager.gainResources(GeneratorType.soft, 10000);
					case("Karma pack") : ResourcesManager.gainResources(GeneratorType.hard, 100);
				}
			}
		}
		
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