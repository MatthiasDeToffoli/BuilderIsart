package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.AdsManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author de Toffoli Matthias
 */
class CarouselCardPackCurrencyVideo extends CarouselCardPack
{

	public function new() 
	{
		super(AssetName.CAROUSSEL_CARD_PACK_CURRENCY_VIDEO);
		
	}
	
	override function _click(pEvent:EventTarget = null):Void 
	{
		AdsManager.playAd(function(pClose:String){});
	}
	
	override function buildCard():Void 
	{
		gain = cast(SmartCheck.getChildByName(this, AssetName.CARD_PACK_GAIN), TextSprite);
		
		var lGainType:GeneratorType = getGainType(myConfig);
		setGain(getGainValue(lGainType, myConfig));
	}
}