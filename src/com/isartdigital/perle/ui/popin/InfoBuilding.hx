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
import com.isartdigital.perle.utils.Interactive;
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
class InfoBuilding extends SmartPopinExtended{
	
	/**
	 * instance unique de la classe InfoBuilding
	 */
	private static var instance: InfoBuilding;
	
	private var btnExit:SmartButton;
	private var btnSell:SmartButton;
	private var btnUpgrade:SmartButton;
	private var btnUpgradeGoldTxt:TextSprite;
	private var btnUpgradeMaterialsTxt:TextSprite;
	private var btnUpgradeMaterialsImage:UISprite;
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
	
	public static var virtualBuilding:VBuilding;
	
	
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
		trace(virtualBuilding);
		setGlobalInfos();
		
		setGoldZone();
		
		setPopulationInfos();
		
		setUpgradeInfos();
		setUpgradeButton();
		
		
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade)){
			fileInfosText();
		}
		
		setImage(virtualBuilding.getAsset());
		

		setButtonsAndAddListeners();
		
	}

	public function linkVirtualBuilding (pVBuilding:VBuilding):Void {
		virtualBuilding = pVBuilding;
	}
	
	public static function getVirtualBuilding():VBuilding{
		return virtualBuilding;
	}
	
	private function fileInfosText():Void{
		
		levelTxt.text = "Level : " + Std.string(cast(virtualBuilding, VBuildingUpgrade).getLevel() + 1);
		upgradeInfosTxt.text = getGoldValuesUpgradeText(cast(virtualBuilding, VBuildingUpgrade).indexLevel);
		upgradeInfosMaterialsTxt.text = getMaterialsValuesUpgradeText(cast(virtualBuilding, VBuildingUpgrade).indexLevel);
		btnUpgradeGoldTxt.text = getGoldValuesUpgradeText(cast(virtualBuilding, VBuildingUpgrade).indexLevel);
		btnUpgradeMaterialsTxt.text = getMaterialsValuesUpgradeText(cast(virtualBuilding, VBuildingUpgrade).indexLevel);
		populationTxt.text = getPopulationText();
		goldZoneTxt.text = getGoldText();
			
		if (cast(virtualBuilding, VBuildingUpgrade).getLevel() >= 2){
			btnUpgrade.parent.removeChild(btnUpgrade);
			btnUpgrade.destroy();
			upgradeInfos.parent.removeChild(upgradeInfos);
			upgradeInfos.destroy();
		}
	}
	
	private function setGlobalInfos():Void{
		
		levelTxt = cast(SmartCheck.getChildByName(this, "Building_Level_txt"), TextSprite);
		nameTxt = cast(SmartCheck.getChildByName(this, "Name"), TextSprite);
		image = cast(SmartCheck.getChildByName(this, "Image"), UISprite); 
		nameTxt.text = FakeTraduction.assetNameNameToTrad(virtualBuilding.getAsset());
	}
	
	private function setPopulationInfos():Void{
		
		population = cast(SmartCheck.getChildByName(this, "Population"), SmartComponent);
		populationTxt = cast(SmartCheck.getChildByName(population, "Window_Infos_txtPopulation"), TextSprite);
	}
	
	/**
	 * Put the correct image in the screen
	 * @param	pAssetName
	 */
	private function setImage (pAssetName:String):Void { 
		
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName);
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();
	}
	
	private function setUpgradeButton():Void{
		
		btnUpgrade = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_UPGRADE), SmartButton);
		btnUpgradeGoldTxt = cast(SmartCheck.getChildByName(btnUpgrade, "_Upgrade_goldValue"), TextSprite);
		btnUpgradeMaterialsTxt = cast(SmartCheck.getChildByName(btnUpgrade, "_Upgrade_ressValue"), TextSprite);
		btnUpgradeMaterialsImage = cast(SmartCheck.getChildByName(btnUpgrade, "_soulIcon_Small"), UISprite);
		
		if (virtualBuilding.alignementBuilding == Alignment.heaven){
			btnUpgradeMaterialsImage.addChild(new UISprite(AssetName.PROD_ICON_WOOD));
			upgradeInfosMaterialsIcon.addChild(new UISprite(AssetName.PROD_ICON_WOOD));
		}
		
		if(virtualBuilding.alignementBuilding == Alignment.hell) {
			btnUpgradeMaterialsImage.addChild(new UISprite(AssetName.PROD_ICON_STONE));
			upgradeInfosMaterialsIcon.addChild(new UISprite(AssetName.PROD_ICON_STONE));
		}
	}
	
	private function setUpgradeInfos():Void{
		
		upgradeInfos = cast(SmartCheck.getChildByName(this, "UpgradeInfo"), SmartComponent);
		upgradeInfosTxt = cast(SmartCheck.getChildByName(upgradeInfos, "ButtonUpgrade_Cost_txt"), TextSprite);
		upgradeInfosMaterialsTxt = cast(SmartCheck.getChildByName(upgradeInfos, "BuildRes1_Text"), TextSprite);
		upgradeInfosGoldIcon = cast(SmartCheck.getChildByName(upgradeInfos, "GoldIcon"), UISprite);
		upgradeInfosGoldIcon.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
		upgradeInfosMaterialsIcon = cast(SmartCheck.getChildByName(upgradeInfos, "BuildRes1_Icon"), UISprite);
	}
	
	private function setGoldZone():Void{
		
		goldZone = cast(SmartCheck.getChildByName(this, "LimitGold"), SmartComponent);
		goldZoneTxt = cast(SmartCheck.getChildByName(goldZone, "Window_Infos_txtGoldLimit"), TextSprite);
		goldZoneImage = cast(SmartCheck.getChildByName(goldZone, "_soft_icon"), UISprite);
		goldZoneImage.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
	}
	
	private function setGoldSeconds():Void{
		
		goldSeconds = cast(SmartCheck.getChildByName(this, "ProductionGold"), SmartComponent);
		goldSecondesTxt = cast(SmartCheck.getChildByName(goldSeconds, "Window_Infos_txtProductionGold"), TextSprite);
		goldSecondesImage = cast(SmartCheck.getChildByName(goldSeconds, "GoldIcon"), UISprite);
		goldSecondesImage.addChild(new UISprite(AssetName.PROD_ICON_SOFT));
		goldSecondesTxt.text = "xxx";
	}
	
	private function setButtonsAndAddListeners():Void{
		
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.BTN_CLOSE), SmartButton);
		btnSell = cast(SmartCheck.getChildByName(this, AssetName.INFO_BUILDING_BTN_SELL), SmartButton);
		
		//@ToDo: bug with the upgrade/destroy via the button
		//Interactive.addListenerClick(btnUpgrade, onClickUpgrade);
		Interactive.addListenerClick(btnExit, onClickExit);
		//Interactive.addListenerClick(btnSell, onClickSell);
	}
	
	/**
	 * Return the correct population for the building House
	 * @return
	 */
	private function getPopulationText():String {
		
		var lPopulationTxt:String;
		var lPop:Population = cast(virtualBuilding, VHouse).getPopulation();
		
		lPopulationTxt = lPop.quantity + "/" + lPop.max;
		
		return lPopulationTxt;
	}
	
	/**
	 * Return the correct gold text for the building House
	 * @return
	 */
	private function getGoldText():String{
		
		var lGeneratorDesc:GeneratorDescription = virtualBuilding.myGenerator.desc;
		var lGoldText:String = lGeneratorDesc.quantity + "/" + lGeneratorDesc.max;
		
		return lGoldText;
	}
	
	/**
	 * Return the correct gold values for the upgrade
	 * @return
	 */
	private function getGoldValuesUpgradeText(pLevel:Int):String{
		
		var lGoldValuesText = cast(virtualBuilding, VBuildingUpgrade).UpgradeGoldValuesList[pLevel];
		
		return lGoldValuesText;
	}
	
	/**
	 * Return the correct material values for the upgrade
	 * @return
	 */
	private function getMaterialsValuesUpgradeText(pLevel:Int):String{
		
		var lMaterialsValuesText = cast(virtualBuilding, VBuildingUpgrade).UpgradeMaterialsValuesList[pLevel];
		
		return lMaterialsValuesText;
	}
	
	/**
	 * Close the popin
	 * @return
	 */
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * Selling of the building
	 * @return
	 */
	private function onClickSell():Void {
		UIManager.getInstance().closeCurrentPopin();
		
		if (Std.is(virtualBuilding, VHouse)) {
			BHHarvestHouse.getInstance().onClickDestroy();
		}
		else BHHarvest.getInstance().onClickDestroy();	
	}
	
	/**
	 * Selling of the building
	 * @return
	 */
	public function sell ():Void {
		
		BuildingHud.linkVirtualBuilding(virtualBuilding);
		BuyManager.sell(virtualBuilding.tileDesc.buildingName, true); // todo : changer true par si le building se construit ou pas
		UIManager.getInstance().closeCurrentPopin();
		virtualBuilding.destroy();
		Hud.getInstance().hideBuildingHud();
		SaveManager.save();
		Hud.getInstance().show();
	}
	
	/**
	 * Upgrade of the building
	 * @return
	 */
	public function onClickUpgrade ():Void {
		var lVBuilding:VBuilding;
		
		if (virtualBuilding != null) lVBuilding = virtualBuilding;
		else lVBuilding = BuildingHud.virtualBuilding;
		
		var lBuildingUpgrade:VBuildingUpgrade = cast(lVBuilding, VBuildingUpgrade);
		
		UIManager.getInstance().closeCurrentPopin(); //always before lBuildingUpgrade else bug when popin levels up appears
		lBuildingUpgrade.onClickUpgrade();
		
		Hud.getInstance().show();
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnUpgrade, onClickUpgrade);
		Interactive.removeListenerClick(btnExit, onClickExit);
		Interactive.removeListenerClick(btnSell, onClickSell);
		
		instance = null;
	}

}