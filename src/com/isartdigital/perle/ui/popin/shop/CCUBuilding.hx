package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUBuilding extends CarousselCardUnlock{

	
	private var textPriceSoft:TextSprite;
	private var textPriceWood:TextSprite;
	private var textPriceIron:TextSprite;
	private var iconIron:UISprite;
	private var iconWood:UISprite;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
	}
	
	private function setRessourcesPrice () {
		textPriceSoft = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PRICE), TextSprite);
		textPriceWood = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice"), TextSprite);
		textPriceIron = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice2"), TextSprite);
		iconIron = cast(SmartCheck.getChildByName(this, "Resource_icon2"), UISprite);
		iconWood = cast(SmartCheck.getChildByName(this, "Resource_icon"), UISprite);
	}
	
	override function buildCard ():Void {
		super.buildCard();
		
		image = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PICTURE), UISprite);
		text_name = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_NAME), TextSprite);
		SmartCheck.traceChildrens(this);
		setRessourcesPrice();
		
		setImage(BuildingName.getAssetName(buildingName));
		setName(FakeTraduction.assetNameNameToTrad(buildingName));
		setPrice(BuyManager.getPrice(buildingName));
	}
	
	override function setName (pString:String):Void {
		text_name.text = pString;
	}
	
	function setPrice (pPrices:Map<GeneratorType, Int>):Void {
		
		textPriceSoft.text = Std.string(pPrices[GeneratorType.soft]);
		
		if (pPrices[GeneratorType.buildResourceFromParadise] == null) {
			removeChild(iconWood);
			removeChild(textPriceWood);
		}
		else
			textPriceWood.text = Std.string(pPrices[GeneratorType.buildResourceFromParadise]);
			
		if (pPrices[GeneratorType.buildResourceFromHell] == null) {
			removeChild(iconIron);
			removeChild(textPriceIron);
		}
		else
			textPriceIron.text = Std.string(pPrices[GeneratorType.buildResourceFromHell]);
		
		
		//iconIron // todo : intégrer ds .fla ou voir gd
		//iconWood
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		
		if (BuyManager.canBuy(buildingName)) {
			Phantom.onClickShop(buildingName);
			Hud.getInstance().hideBuildingHud();
			Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
		}
		
		// todo : il close le shop même si canBuy == false  :(
	}
	
}