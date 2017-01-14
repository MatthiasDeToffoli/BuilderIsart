package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.building.VirtuesBuilding;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.ui.hud.building.BHBuilt;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHHarvestHouse;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author ambroise
 */
class InfoBuilding extends SmartPopin {
	
	/**
	 * instance unique de la classe InfoBuilding
	 */
	private static var instance: InfoBuilding;
	
	private var btnExit:SmartButton;
	private var btnSell:SmartButton;
	private var btnUpgrade:SmartButton;
	private var levelTxt:TextSprite;
	private var nameTxt:TextSprite;
	private var limitGoldTxt:TextSprite;
	private var image:UISprite;
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): InfoBuilding {
		if (instance == null) instance = new InfoBuilding();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super(AssetName.POPIN_INFO_BUILDING);
		
		SmartCheck.traceChildrens(this);
		
		levelTxt = cast(SmartCheck.getChildByName(this, "Building_Level_txt"), TextSprite);
		nameTxt = cast(SmartCheck.getChildByName(this, "Name"), TextSprite);
		//limitGoldTxt = cast(SmartCheck.getChildByName(this, "ProductionGold"), TextSprite);

		btnExit = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_CLOSE), SmartButton);
		btnSell = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_SELL), SmartButton);
		btnUpgrade = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_UPGRADE), SmartButton);
		image = cast(SmartCheck.getChildByName(this, "Image"), UISprite); 
		
		nameTxt.text = FakeTraduction.assetNameNameToTrad(BuildingHud.virtualBuilding.getAsset());
		levelTxt.text = "Level : " + Std.string(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel + 1);
		//limitGoldTxt.text = "5/5";
		
		setImage(BuildingHud.virtualBuilding.getAsset());
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnSell.on(MouseEventType.CLICK, onClickSell);
		
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade)){
			var myVBuilding:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
			if (myVBuilding.canUpgrade()){
				btnUpgrade.on(MouseEventType.CLICK, onClickUpgrade);
				return;
			}
		}
		
		btnUpgrade.parent.removeChild(btnUpgrade);
		btnUpgrade.destroy();
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickSell():Void {
		UIManager.getInstance().closeCurrentPopin();
		
		if (Std.is(BuildingHud.virtualBuilding, VHouse)){
			BHHarvestHouse.getInstance().onClickDestroy();	
		}
		else
			BHHarvest.getInstance().onClickDestroy();	
	}
	
	public function sell ():Void {
		BuyManager.sell(cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName());
		UIManager.getInstance().closeCurrentPopin();
		BuildingHud.virtualBuilding.destroy();
		Hud.getInstance().hideBuildingHud();
		SaveManager.save();
	}
	
	public function onClickUpgrade ():Void {
		var lAssetName:String = BuildingHud.virtualBuilding.tileDesc.assetName;
		var lBuildingUpgrade:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
		
		UIManager.getInstance().closeCurrentPopin(); //always before lBuildingUpgrade else bug when popin level up appear
		lBuildingUpgrade.onClickUpgrade();
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}