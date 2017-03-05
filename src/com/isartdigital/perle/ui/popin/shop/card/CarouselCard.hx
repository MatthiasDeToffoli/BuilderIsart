package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.shop.ConfirmBuyBuilding;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CarouselCard extends SmartButtonExtended {
	
	private var image:UISprite;
	private var btnDesc:SmartButton;
	
	public function new(pAsset:String) {
		super(pAsset);
	}
	
	/**
	 * Do what you want whit pName in descendant (héritage)
	 * @param	pName
	 */
	public function init (pName:String):Void {
		isInit = true;
		buildCard();
	}
	
	override private function _mouseDown (pEvent:EventTarget = null): Void {
		super._mouseDown(pEvent);
		if (isInit) // i've tried using build function override, doesn't seem to work
			buildCard();
	}
	
	override private function _mouseOver (pEvent:EventTarget = null): Void {
		super._mouseOver(pEvent);
		if (isInit)
			buildCard();
	}
	
	override private function _mouseOut (pEvent:EventTarget = null): Void {
		super._mouseOut(pEvent);
		if (isInit)
			buildCard();
	}
	
	/**
	 * Add description btn, that open a popin info building.
	 * Only for card lock and unlock (deco and building)
	 * Call this function in the init override.
	 */
	private function addDescriptionBtn ():Void {
		btnDesc = new SmartButton(AssetName.CAROUSSEL_CARD_BTN_INFO);
		// todo: ask GD for a spawner
		// value pre-calculated from .fla
		btnDesc.x = x + 103;
		btnDesc.y = y - 42.5;
		Interactive.addListenerClick(btnDesc, onClickDesc);
		on(EventType.ADDED, function () {
			parent.addChild(btnDesc);
		});
	}
	
	/**
	 * Override this method to add ConfirmBuyBuilding.getInstance().init(*)
	 */
	private function onClickDesc ():Void {}
	
	// todo faire un tween sympa ?
	/*private function tweenPopin ():Void {
		TweenMax.to(scale, TWEEN_DURATION, {
			ease: untyped Back.easeOut.config(TWEEN_BACK_PARAM_1),
			x:1,
			y:1
		} );
	}*/

	private function closeShop ():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	override public function destroy():Void {
		if (btnDesc != null) {	
			btnDesc.removeAllListeners();
			btnDesc.parent.removeChild(btnDesc);
			btnDesc.destroy();
		}
		
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}