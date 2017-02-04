package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author ambroise
 */
class CarouselCardPack extends CarouselCard{

	private var cardName:String;
	private var price:TextSprite;
	private var icon:UISprite;
	private var textName:TextSprite;
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
		btn = cast(SmartCheck.getChildByName(this, "Button"), SmartButton);
		price = cast(SmartCheck.getChildByName(btn, AssetName.CARD_PACK_PRICE), TextSprite);
		icon = cast(SmartCheck.getChildByName(btn, AssetName.CARD_PACK_ICON), UISprite);
		textName = cast(SmartCheck.getChildByName(btn, AssetName.CARD_PACK_NAME), TextSprite);
		picture = cast(SmartCheck.getChildByName(btn, AssetName.CARD_PACK_PICTURE), UISprite);
		
		var lConfig:TableTypeShopPack = GameConfig.getShopPackByName(cardName);
		
		setPrice(lConfig.priceIP == null ? lConfig.priceKarma : lConfig.priceIP);
		setIcon();
		setName(cardName);
		setPicture();
	}
	
	
	private function setPrice (pInt:Float):Void {
		price.text = Std.string(pInt);
	}
	
	private function setIcon ():Void {
	}
	
	private function setName (pString:String):Void {
		textName.text = pString;
	}
	
	private function setPicture ():Void {
	}
	
}