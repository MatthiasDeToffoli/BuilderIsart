package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class CarouselCardPack extends CarouselCard{

	private var cardName:String;
	private var price:TextSprite;
	private var iconGain:UISprite;
	private var iconPrice:UISprite;
	private var gain:TextSprite;
	private var picture:UISprite;
	private var btn:SmartButton;// les gd l'ont construit bizarrement...
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	override public function init(pName:String):Void {
		cardName = pName;
		super.init(pName);
	}
	
	override private function buildCard():Void {
		super.buildCard();
		//btn = cast(SmartCheck.getChildByName(this, "Button"), SmartButton);
		price = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_PRICE), TextSprite);
		iconGain = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_ICON_GAIN), UISprite);
		iconPrice = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_ICON_PRICE), UISprite);
		gain = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_GAIN), TextSprite);
		picture = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_PICTURE), UISprite);
		
		var lConfig:TableTypeShopPack = GameConfig.getShopPackByName(cardName);
		var lPriceType:GeneratorType = getPriceType(lConfig);
		var lGainType:GeneratorType = getGainType(lConfig);
		
		setPrice(lConfig.priceIP == null ? lConfig.priceKarma : lConfig.priceIP);
		setIconPrice(lPriceType);
		setIconGain(lGainType);
		setGain(getGainValue(lGainType, lConfig));
		setPicture(lGainType, lConfig.iconLevel);
		//setName(cardName); there is no name testSprite.
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
	
	
	private function setPrice (pFloat:Float):Void {
		price.text = Std.string(pFloat);
	}

	private function setGain (pInt:Int):Void {
		gain.text = addkToInt(cast(pInt, Float));
	}
	
	private function addkToInt (pFloat:Float):String {
		return pFloat > 1000 ? Std.string(pFloat / 1000) + "k" : Std.string(pFloat);
	}
	
	private function setIconPrice (pGainType:GeneratorType):Void {
		switch (pGainType) {
			//case GeneratorType.isartPoint :; // do nothing, icon already set
			case GeneratorType.hard : changeIconSpawner(AssetName.PROD_ICON_HARD, iconPrice);
			default : null;
		}
	}
	
	private function setIconGain (pGainType:GeneratorType):Void {
		switch (pGainType) {
			case GeneratorType.soft : changeIconSpawner(AssetName.PROD_ICON_SOFT, iconGain);
			case GeneratorType.hard : changeIconSpawner(AssetName.PROD_ICON_HARD, iconGain);
			case GeneratorType.buildResourceFromHell : changeIconSpawner(AssetName.PROD_ICON_STONE, iconGain);
			case GeneratorType.buildResourceFromParadise : changeIconSpawner(AssetName.PROD_ICON_WOOD, iconGain);
			default : null;
		}
	}
	
	private function changeIconSpawner (pSpriteName:String, pSpawner:UISprite):Void {
		var lSprite:UISprite = new UISprite(pSpriteName);
		lSprite.position = pSpawner.position;
		addChild(lSprite);
		removeChild(pSpawner);
		pSpawner.destroy();
		pSpawner = lSprite;
	}
	
	/*private function setName (pString:String):Void {
		textName.text = pString;
	}*/
	
	/**
	 * Set the picture for the card, level begin from 1, and goes max to 5
	 * @param	pGainType
	 * @param	pIconLevel
	 */
	private function setPicture (pGainType:GeneratorType, pIconLevel:Int):Void {
		
		if (pIconLevel < 1 || pIconLevel > 5)
			Debug.error("pIconLevel level is not supported ! (must be between 1 and 5 included)");
		
		var lSwitch:Map<GeneratorType, Map<Int,String>> = [
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
		
		for (type in lSwitch.keys()) {
			if (type == pGainType) {
				for (level in lSwitch[pGainType].keys()) {
					if (level == pIconLevel) {
						changeIconSpawner(lSwitch[pGainType][pIconLevel], picture);
						return;
					}
				}
			}
		}
		Debug.error("Could not find picture for CarouselCardPack");
	}
	
}