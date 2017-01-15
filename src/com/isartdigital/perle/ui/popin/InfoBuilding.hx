package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.ResourcesManager.Population;
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
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * Poppin of the description of the building
 * @author Emeline Berenguier
 */
class InfoBuilding extends SmartPopin{
	
	/**
	 * instance unique de la classe InfoBuilding
	 */
	private static var instance: InfoBuilding;
	
	private var btnExit:SmartButton;
	private var btnSell:SmartButton;
	private var btnUpgrade:SmartButton;
	private var btnUpgradeGoldTxt:TextSprite;
	private var btnUpgradeMaterialsTxt:TextSprite;
	private var levelTxt:TextSprite;
	private var nameTxt:TextSprite;
	private var image:UISprite;
	private var background:UISprite;
	private var goldSeconds:SmartComponent;
	private var goldSecondesTxt:TextSprite;
	private var goldSecondesImage:UISprite;
	private var population:SmartComponent;
	private var populationTxt:TextSprite;
	private var goldZone:SmartComponent;
	private var goldZoneTxt:TextSprite;
	private var goldZoneImage:UISprite;
	private var upgradeInfos:SmartComponent;
	private var upgradeInfosGoldIcon:UISprite;
	private var upgradeInfosMaterialsIcon:UISprite;
	private var upgradeInfosTxt:TextSprite;
	private var upgradeInfosMaterialsTxt:TextSprite;
	
	public var virtualBuilding:VBuilding;
	
	
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
		
		levelTxt = cast(SmartCheck.getChildByName(this, "Building_Level_txt"), TextSprite);
		nameTxt = cast(SmartCheck.getChildByName(this, "Name"), TextSprite);
		
		goldSeconds = cast(SmartCheck.getChildByName(this, "ProductionGold"), SmartComponent);
		goldSecondesTxt = cast(SmartCheck.getChildByName(goldSeconds, "Window_Infos_txtProductionGold"), TextSprite);
		goldSecondesImage = cast(SmartCheck.getChildByName(goldSeconds, "GoldIcon"), UISprite);
		goldSecondesImage.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
		
		goldZone = cast(SmartCheck.getChildByName(this, "LimitGold"), SmartComponent);
		goldZoneTxt = cast(SmartCheck.getChildByName(goldZone, "Window_Infos_txtGoldLimit"), TextSprite);
		goldZoneImage = cast(SmartCheck.getChildByName(goldZone, "_soft_icon"), UISprite);
		goldZoneImage.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
				
		population = cast(SmartCheck.getChildByName(this, "Population"), SmartComponent);
		populationTxt = cast(SmartCheck.getChildByName(population, "Pack_Content_txt"), TextSprite);
		
		upgradeInfos = cast(SmartCheck.getChildByName(this, "UpgradeInfo"), SmartComponent);
		upgradeInfosTxt = cast(SmartCheck.getChildByName(upgradeInfos, "ButtonUpgrade_Cost_txt"), TextSprite);
		upgradeInfosMaterialsTxt = cast(SmartCheck.getChildByName(upgradeInfos, "BuildRes1_Text"), TextSprite);
		upgradeInfosGoldIcon = cast(SmartCheck.getChildByName(upgradeInfos, "GoldIcon"), UISprite);
		upgradeInfosGoldIcon.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
		upgradeInfosMaterialsIcon = cast(SmartCheck.getChildByName(upgradeInfos, "BuildRes1_Icon"), UISprite);
		
		if (BuildingHud.virtualBuilding.alignementBuilding == Alignment.heaven)
			upgradeInfosMaterialsIcon.addChild(new UISprite(AssetName.PROD_ICON_WOOD));
		if (BuildingHud.virtualBuilding.alignementBuilding == Alignment.hell)
			upgradeInfosMaterialsIcon.addChild(new UISprite(AssetName.PROD_ICON_STONE));
			
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_CLOSE), SmartButton);
		//btnSell = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_SELL), SmartButton);
		
		btnUpgrade = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_UPGRADE), SmartButton);
		btnUpgradeGoldTxt = cast(SmartCheck.getChildByName(btnUpgrade, "_Upgrade_goldValue"), TextSprite);
		btnUpgradeMaterialsTxt = cast(SmartCheck.getChildByName(btnUpgrade, "_Upgrade_ressValue"), TextSprite);

		image = cast(SmartCheck.getChildByName(this, "Image"), UISprite); 
		nameTxt.text = FakeTraduction.assetNameNameToTrad(BuildingHud.virtualBuilding.getAsset());
				
		levelTxt.text = "Level : " + Std.string(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel + 1);
		goldSecondesTxt.text = "xxx";
		populationTxt.text = getPopulationText();
		goldZoneTxt.text = getGoldText();
		upgradeInfosTxt.text = getGoldValuesUpgradeText(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel);
		upgradeInfosMaterialsTxt.text = getMaterialsValuesUpgradeText(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel);
		btnUpgradeGoldTxt.text = getGoldValuesUpgradeText(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel);
		btnUpgradeMaterialsTxt.text = getMaterialsValuesUpgradeText(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel);
		
		setImage(BuildingHud.virtualBuilding.getAsset());
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		//btnSell.on(MouseEventType.CLICK, onClickSell);
		
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
	
	public function linkVirtualBuilding (pVBuilding:VBuilding):Void {
		virtualBuilding = pVBuilding;
	}
	
	public function getVirtualBuilding():VBuilding{
		return virtualBuilding;
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();
	}
	
	private function getPopulationText():String {
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		var lPopulationTxt:String;
		var lPop:Population = cast(lVBuilding, VHouse).getPopulation();
		
		lPopulationTxt = lPop.quantity + "/" + lPop.max;
		
		return lPopulationTxt;
	}
	
	private function getGoldText():String{
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		var lGeneratorDesc:GeneratorDescription = lVBuilding.myGenerator.desc;
		var lGoldText:String = lGeneratorDesc.quantity + "/" + lGeneratorDesc.max;
		
		return lGoldText;
	}
	
	private function getGoldValuesUpgradeText(pLevel:Int):String{
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		var lGoldValuesText = cast(lVBuilding, VBuildingUpgrade).UpgradeGoldValuesList[pLevel];
		
		return lGoldValuesText;
	}
	
	private function getMaterialsValuesUpgradeText(pLevel:Int):String{
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		var lMaterialsValuesText = cast(lVBuilding, VBuildingUpgrade).UpgradeMaterialsValuesList[pLevel];
		
		return lMaterialsValuesText;
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickSell():Void {
		UIManager.getInstance().closeCurrentPopin();
		
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		trace(virtualBuilding);
		if (Std.is(virtualBuilding, VHouse)) BHHarvestHouse.getInstance().onClickDestroy();

		else BHHarvest.getInstance().onClickDestroy();	
	}
	
	public function sell ():Void {
		BuyManager.sell(cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName());
		UIManager.getInstance().closeCurrentPopin();
		BuildingHud.virtualBuilding.destroy();
		Hud.getInstance().hideBuildingHud();
		SaveManager.save();
	}
	
	public function onClickUpgrade ():Void {
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = virtualBuilding;
		
		var lAssetName:String = lVBuilding.tileDesc.assetName;
		var lBuildingUpgrade:VBuildingUpgrade = cast(lVBuilding, VBuildingUpgrade);
		
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