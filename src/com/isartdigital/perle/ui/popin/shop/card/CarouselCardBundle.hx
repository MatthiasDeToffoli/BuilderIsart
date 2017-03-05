package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCardBundle extends CarouselCard{

	private static var pictureSwitch(default, never):Map<Int,String> = [
		1 => AssetName.CARD_BUNDLE_PICTURE_1,
		2 => AssetName.CARD_BUNDLE_PICTURE_2,
		3 => AssetName.CARD_BUNDLE_PICTURE_3,
		4 => AssetName.CARD_BUNDLE_PICTURE_4
	];
	
	private var myConfig:TableTypeShopPack;
	private var cardName:String;
	private var picture:UISprite;
	private var textName:TextSprite;
	private var textCostIP:TextSprite;
	private var textGainIron:TextSprite;
	private var textGainWood:TextSprite;
	private var textGainSoft:TextSprite;
	private var textGainHard:TextSprite;
	private var iconGainIron:UISprite;
	private var iconGainWood:UISprite;
	private var iconGainSoft:UISprite;
	private var iconGainHard:UISprite;
	
	private var cantBuyFeedBack:Bool;
	private var myPrice:Map<GeneratorType, Float>;
	private var myGain:Map<GeneratorType, Int>;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_BUNDLE);
		
	}
	
	override public function init(pName:String):Void {
		cardName = pName;
		myConfig = GameConfig.getShopPackByName(cardName);
		myPrice = [GeneratorType.isartPoint => myConfig.priceIP];
		myGain = [
			GeneratorType.buildResourceFromHell => myConfig.giveIron,
			GeneratorType.buildResourceFromParadise => myConfig.giveWood,
			GeneratorType.soft => myConfig.giveGold,
			GeneratorType.hard => myConfig.giveKarma
		];
		cantBuyFeedBack = !BuyManager.canBuyShopPack(myPrice);
		
		super.init(pName);
	}
	
	override private function buildCard():Void {
		super.buildCard();
		
		// todo: un peu du bricolage ce alpha.
		if (cantBuyFeedBack) 
			alpha = 0.5;
		picture = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_PICTURE), UISprite);
		textName = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_NAME), TextSprite);
		textCostIP = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_COST_IP), TextSprite);
		textGainIron = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_GAIN_IRON), TextSprite);
		textGainWood = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_GAIN_WOOD), TextSprite);
		textGainSoft = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_GAIN_SOFT), TextSprite);
		textGainHard = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_TEXT_GAIN_HARD), TextSprite);
		iconGainIron = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_ICON_GAIN_IRON), UISprite);
		iconGainWood = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_ICON_GAIN_WOOD), UISprite);
		iconGainSoft = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_ICON_GAIN_SOFT), UISprite);
		iconGainHard = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUNDLE_ICON_GAIN_HARD), UISprite);
		
		
		setPicture(picture, myConfig.iconLevel, pictureSwitch);
		//textName.text = FakeTraduction.assetNameNameToTrad(cardName);
		textName.text = Localisation.getText(cardName);
		textCostIP.text = Std.string(myConfig.priceIP);
		setGain(textGainIron, iconGainIron, myConfig.giveIron);
		setGain(textGainWood, iconGainWood, myConfig.giveWood);
		setGain(textGainSoft, iconGainSoft, myConfig.giveGold);
		setGain(textGainHard, iconGainHard, myConfig.giveKarma);
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
		SaveManager.saveLockBundle(myConfig.iD);
		ShopPopin.getInstance().setCurrenciesNumber();
	}
	
	private function setPicture (pPicture:UISprite, pIconLevel:Int, lPictureSwitch:Map<Int,String>):Void {
		for (level in lPictureSwitch.keys()) {
			if (level == pIconLevel) {
				SmartPopinExtended.setIcon(lPictureSwitch[pIconLevel], pPicture);
				return;
			}
		}
		Debug.error("Could not find picture for CarouselCardbundle");
	}
	
	private function setGain (pTextSprite:TextSprite, pIcon:UISprite, pValue:Int):Void {
		if (pValue != null) {
			pTextSprite.text = ResourcesManager.shortenValue(pValue);
		} else {
			removeChild(pTextSprite);
			removeChild(pIcon);
			pTextSprite.destroy();
			pIcon.destroy();
			pTextSprite = null;
			pIcon = null;
		}
		
	}
}