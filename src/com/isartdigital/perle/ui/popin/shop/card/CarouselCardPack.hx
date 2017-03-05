package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.dialogue.GoldEffect;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import js.Browser;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCardPack extends CarouselCard{

	private static var pictureSwitch(default, never):Map<GeneratorType, Map<Int,String>> = [
		GeneratorType.soft => [
			1 => AssetName.CARD_PACK_PICTURE_GOLD_1,
			2 => AssetName.CARD_PACK_PICTURE_GOLD_2,
			3 => AssetName.CARD_PACK_PICTURE_GOLD_3,
			4 => AssetName.CARD_PACK_PICTURE_GOLD_4,
			5 => AssetName.CARD_PACK_PICTURE_GOLD_5
		],
		GeneratorType.hard => [
			1 => AssetName.CARD_PACK_PICTURE_KARMA_1,
			2 => AssetName.CARD_PACK_PICTURE_KARMA_2,
			3 => AssetName.CARD_PACK_PICTURE_KARMA_3,
			4 => AssetName.CARD_PACK_PICTURE_KARMA_4,
			5 => AssetName.CARD_PACK_PICTURE_KARMA_5
		],
		GeneratorType.buildResourceFromHell => [
			1 => AssetName.CARD_PACK_PICTURE_IRON_1,
			2 => AssetName.CARD_PACK_PICTURE_IRON_2,
			3 => AssetName.CARD_PACK_PICTURE_IRON_3
		],
		GeneratorType.buildResourceFromParadise => [
			1 => AssetName.CARD_PACK_PICTURE_WOOD_1,
			2 => AssetName.CARD_PACK_PICTURE_WOOD_2,
			3 => AssetName.CARD_PACK_PICTURE_WOOD_3
		]
	];
	
	private var myConfig:TableTypeShopPack;
	private var cardName:String;
	private var price:TextSprite;
	private var iconGain:UISprite;
	private var iconPrice:UISprite;
	private var gain:TextSprite;
	private var picture:UISprite;
	
	private var cantBuyFeedBack:Bool;
	private var myPrice:Map<GeneratorType, Float>;
	private var myGain:Map<GeneratorType, Int>;
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	override public function init(pName:String):Void {
		// note : i use the buildingName for the other tab to know which cards i need to show.
		// cardName is not used, but if i want to use properly my parent methods, i need
		// to give a unique name for my card.
		// maybe i could use Std.string(iD) from dataBase instead.
		
		cardName = pName;
		myConfig = GameConfig.getShopPackByName(cardName);
		myPrice = [
			getPriceType(myConfig) => getPriceValue(getPriceType(myConfig), myConfig)
		];
		myGain = [
			getGainType(myConfig) => getGainValue(getGainType(myConfig), myConfig)
		];
		cantBuyFeedBack = !BuyManager.canBuyShopPack(myPrice);
		super.init(pName);
	}
	
	override private function buildCard():Void {
		super.buildCard();
		
		// todo: un peu du bricolage ce alpha.
		if (cantBuyFeedBack) 
			alpha = 0.5;
		
		price = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_PRICE), TextSprite);
		iconGain = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_ICON_GAIN), UISprite);
		iconPrice = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_ICON_PRICE), UISprite);
		gain = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_GAIN), TextSprite);
		picture = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_PICTURE), UISprite);
		
		// todo : répétitif
		var lPriceType:GeneratorType = getPriceType(myConfig);
		var lGainType:GeneratorType = getGainType(myConfig);
		
		setPrice(getPriceValue(lPriceType, myConfig));
		setIconPrice(lPriceType);
		setIconGain(lGainType);
		setGain(getGainValue(lGainType, myConfig));
		setPicture(picture, lGainType, myConfig.iconLevel, pictureSwitch);
		//setName(cardName); there is no name testSprite.
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		if (!BuyManager.canBuyShopPack(myPrice)) {
			trace("You don't have the money for this ShopPack");
			Browser.alert("You don't have the money for this ShopPack");
			return;
		}
		
		super._click(pEvent);
		SoundManager.getSound("SOUND_SPEND").play();
		//closeShop();
		BuyManager.buyShopPack(myPrice, myGain, myConfig.iD);
		ShopPopin.getInstance().setCurrenciesNumber();
	}
	
	
	private function getPriceType (pConfig:TableTypeShopPack):GeneratorType {
		if (pConfig.priceIP != null) return GeneratorType.isartPoint;
		if (pConfig.priceKarma != null) return GeneratorType.hard;
		
		Debug.error("Price not set for CarouselCardPack");
		return null;
	}
	
	private function getGainType (pConfig:TableTypeShopPack):GeneratorType {
		if (pConfig.giveGold != null) return GeneratorType.soft;
		if (pConfig.giveIron != null) return GeneratorType.buildResourceFromHell;
		if (pConfig.giveKarma != null) return GeneratorType.hard;
		if (pConfig.giveWood != null) return GeneratorType.buildResourceFromParadise;
		
		Debug.error("Gain not set for CarouselCardPack");
		return null;
	}
	
	private function getGainValue (pGainType:GeneratorType, pConfig:TableTypeShopPack):Int {
		switch (pGainType) {
			case GeneratorType.soft : return pConfig.giveGold;
			case GeneratorType.hard : return pConfig.giveKarma;
			case GeneratorType.buildResourceFromHell : return pConfig.giveIron;
			case GeneratorType.buildResourceFromParadise : return pConfig.giveWood;
			default : null;
		}
		
		Debug.error("Gain is unknow, error in database ?");
		return null;
	}
	
	private function getPriceValue (pPriceType:GeneratorType, pConfig:TableTypeShopPack):Float {
		switch (pPriceType) {
			case GeneratorType.isartPoint : return pConfig.priceIP;
			case GeneratorType.hard : return pConfig.priceKarma;
			default : null;
		}
		
		Debug.error("Price is unknow, error in database ?");
		return null;
	}
	
	private function setPrice (pFloat:Float):Void {
		price.text = Std.string(pFloat);
	}

	private function setGain (pInt:Int):Void {
		gain.text = ResourcesManager.shortenValue(pInt);
	}
	
	private function setIconPrice (pGainType:GeneratorType):Void {
		switch (pGainType) {
			//case GeneratorType.isartPoint :; // do nothing, icon already set
			case GeneratorType.hard : SmartPopinExtended.setIcon(AssetName.PROD_ICON_HARD_SMALL, iconPrice);
			default : null;
		}
	}
	
	private function setIconGain (pGainType:GeneratorType):Void {
		switch (pGainType) {
			case GeneratorType.soft : SmartPopinExtended.setIcon(AssetName.PROD_ICON_SOFT_SMALL, iconGain);
			case GeneratorType.hard : SmartPopinExtended.setIcon(AssetName.PROD_ICON_HARD_SMALL, iconGain);
			case GeneratorType.buildResourceFromHell : SmartPopinExtended.setIcon(AssetName.PROD_ICON_STONE_SMALL, iconGain);
			case GeneratorType.buildResourceFromParadise : SmartPopinExtended.setIcon(AssetName.PROD_ICON_WOOD_SMALL, iconGain);
			default : null;
		}
	}
	
	/**
	 * Set the picture for the card, level begin from 1, and goes max to 5
	 * @param	pGainType
	 * @param	pIconLevel
	 */
	private function setPicture (pPicture:UISprite, pGainType:GeneratorType, pIconLevel:Int, lPictureSwitch:Map<GeneratorType, Map<Int,String>>):Void {
		for (type in lPictureSwitch.keys()) {
			if (type == pGainType) {
				for (level in lPictureSwitch[pGainType].keys()) {
					if (level == pIconLevel) {
						SmartPopinExtended.setIcon(lPictureSwitch[pGainType][pIconLevel], pPicture);
						return;
					}
				}
			}
		}
		Debug.error("Could not find picture for CarouselCardPack or CarouselCardbundle");
	}
	
	/*private function setName (pString:String):Void {
		textName.text = pString;
	}*/
	
}