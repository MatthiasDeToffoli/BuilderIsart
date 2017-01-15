package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author ambroise
 */
class CCLBuilding extends CarousselCardLock{

	public function new() {
		super();
	}
	
	override public function init(pBuildingAssetName:String):Void {
		super.init(pBuildingAssetName);
		setImage(buildingAssetName);
	}
}