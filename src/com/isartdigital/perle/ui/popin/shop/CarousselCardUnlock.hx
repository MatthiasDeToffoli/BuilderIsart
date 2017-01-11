package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Alexis
 */
class CarousselCardUnlock extends CarouselCard
{
	private var imageCurrency:UISprite;
	private var text_name:TextSprite;
	private var text_price:TextSprite;
	
	override public function new() 
	{
		super(AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED);
		
		//image = cast(SmartCheck.getChildByName(this, "Item_Picture"), UISprite); // todo : finir
		imageCurrency = cast(SmartCheck.getChildByName(this, "Currency_icon"), UISprite);
		text_name = cast(SmartCheck.getChildByName(this, "Item_Name"), TextSprite);
		text_price = cast(SmartCheck.getChildByName(this, "Item_Price"), TextSprite);
	}
	
	
	
	override public function init (pBuildingAssetName:String):Void {
		super.init(pBuildingAssetName);
		// image = pBuildingAssetName ....
		// text idem voir buyManager ?
		setName(buildingAssetName);
		setPrice(Math.floor(Math.random()*2000)); // todo: bon item price par rapprt au json
	}
	
	override public function start ():Void {
		super.start();
		/*interactive = true;
		on(MouseEventType.CLICK, onClick);*/
	}
	
	private function setName (pString:String):Void {
		text_name.text = pString;
	}
	
	private function setPrice (pInt:Int):Void {
		text_price.text = Std.string(pInt);
	}
	
	override private function _click (pEvent:EventTarget=null):Void {
		super._click(pEvent);
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
		ConfirmBuyBuilding.getInstance().init(buildingAssetName);
	}
	
	override public function destroy():Void {
		//removeListener(MouseEventType.CLICK, onClick);
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}