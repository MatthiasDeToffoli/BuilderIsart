package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUBuilding extends CarouselCardUnlock{

	private var text_name:TextSprite;
	private var textPriceSoftHard:TextSprite;
	private var textPriceWood:TextSprite;
	private var textPriceIron:TextSprite;
	private var iconSoftHard:UISprite;
	private var iconIron:UISprite;
	private var iconWood:UISprite;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_UNLOCKED);
		name = componentName;
	}
	
	private function setRessourcesPrice () {
		textPriceSoftHard = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PRICE), TextSprite);
		textPriceWood = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice"), TextSprite); // todo: contantes
		textPriceIron = cast(SmartCheck.getChildByName(this, "Item_ResourcePrice2"), TextSprite);
		iconSoftHard = cast(SmartCheck.getChildByName(this, "Currency_icon"), UISprite);
		iconIron = cast(SmartCheck.getChildByName(this, "Resource_icon2"), UISprite);
		iconWood = cast(SmartCheck.getChildByName(this, "Resource_icon"), UISprite);
	}
	
	override function buildCard ():Void {
		super.buildCard();
		
		image = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_PICTURE), UISprite);
		text_name = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_CARD_NAME), TextSprite);
		
		setRessourcesPrice();
		
		SmartPopinExtended.setImage(image, BuildingName.getAssetName(buildingName));
		setName(FakeTraduction.assetNameNameToTrad(buildingName));
		setPrice(BuyManager.getPrice(buildingName));
	}
	
	override function setName (pString:String):Void {
		text_name.text = pString;
	}
	
	private function setPrice (pPrices:Map<GeneratorType, Int>):Void {
		
		textPriceSoftHard.text = Std.string(pPrices[GeneratorType.soft]);
		
		setWoodPrice(pPrices[GeneratorType.buildResourceFromParadise]);
		setIronPrice(pPrices[GeneratorType.buildResourceFromHell]);
	}
	
	private function setWoodPrice (pPrice:Int):Void {
		if (pPrice == null) {
			removeChild(iconWood);
			removeChild(textPriceWood);
		}
		else
			textPriceWood.text = Std.string(pPrice);
	}
	
	private function setIronPrice (pPrice:Int):Void {
		if (pPrice == null) {
			removeChild(iconIron);
			removeChild(textPriceIron);
		}
		else
			textPriceIron.text = Std.string(pPrice);
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		if (DialogueManager.ftueStepClickOnCard || BuyManager.canBuy(buildingName)) {
			if (DialogueManager.ftueStepClickOnCard)
				DialogueManager.endOfaDialogue();
			Phantom.onClickShop(buildingName);
			Hud.getInstance().hideBuildingHud();
			Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
		}
		
		// todo : il close le shop même si canBuy == false  :(
	}
	
}