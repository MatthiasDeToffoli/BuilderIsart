package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCardPackCurrency extends CarouselCardPack{

	public function new() {
		super(AssetName.CAROUSSEL_CARD_PACK_CURRENCY);
		
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		SoundManager.getSound("SOUND_SPEND").play();
		if (myConfig.priceIP != null && myConfig.priceIP > 0)
			DeltaDNAManager.sendIsartPointExpense(myConfig.iD, myConfig.priceIP);
	}
	
}