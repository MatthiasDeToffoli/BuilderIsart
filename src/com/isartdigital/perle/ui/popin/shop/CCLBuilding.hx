package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
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
	
	override public function init(pBuildingName:String):Void {
		super.init(pBuildingName);
		setImage(BuildingName.getAssetName(buildingName));
	}
}