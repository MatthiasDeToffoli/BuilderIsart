package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCaroussel;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class ShopCarousselInterns extends ShopCaroussel{

	public static var internsNameList(default, never):Array<String> = [ // renommé et majuscules. mettre en bdd ?
	];
	
	private var btnReroll:SmartButton;
	
	public function new() {
		super(AssetName.SHOP_CAROUSSEL_INTERN);
		btnReroll = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_INTERN_BTN_REROLL), SmartButton);
	}
	
	override public function init (pPos:Point, pTab:ShopTab):Void {
		super.init(pPos,myEnum);
		Interactive.addListenerClick(btnReroll, onClickReroll);
	}
	
	/**
	 * Funciton disabled that function because there is no arrow for intern tab.
	 */
	override function initArrows():Void {}
	
	override private function getSpawnersAssetNames():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			/*"Shop_Intern_1",
			"Shop_Intern_2",
			"Shop_Intern_3"*/
		];
	}
	
	private function onClickReroll ():Void {
		ShopPopin.getInstance().init(ShopTab.InternsSearch);
	}
	
	override function getCardToShow():Array<String> {
		return new Array<String>();
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnReroll, onClickReroll);
		super.destroy();
	}
	
}