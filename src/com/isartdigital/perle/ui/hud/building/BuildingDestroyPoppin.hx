package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Alexis
 */
class BuildingDestroyPoppin extends SmartPopin 
{
	private var image:UISprite;
	private var nameBuilding:TextSprite;
	private var levelBuilding:TextSprite;
	private var price:TextSprite;
	private var btnClose:SmartButton;
	private var btnSell:SmartButton;
	private var btnSellText:TextSprite;
	
	/**
	 * instance unique de la classe BuildingDestroyPoppin
	 */
	private static var instance: BuildingDestroyPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BuildingDestroyPoppin {
		if (instance == null) instance = new BuildingDestroyPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une istance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.DESTROY_POPPIN);
		addListeners();
		
		
		//levelBuilding.text = "Level : " + Std.string(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).indexLevel + 1);
		
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = InfoBuilding.getVirtualBuilding();
		
		nameBuilding.text = FakeTraduction.assetNameNameToTrad(BuildingHud.virtualBuilding.tileDesc.buildingName);
		
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade))
			levelBuilding.text = "Level : " + Std.string(cast(lVBuilding, VBuildingUpgrade).getLevel());
		else levelBuilding.text = "";
		
		setImage(lVBuilding.getAsset());
		price.text = ""+ BuyManager.getSellPrice(lVBuilding.tileDesc.buildingName, true).get(GeneratorType.soft); // todo
	}
	
	private function setImage (pAssetName:String):Void { // todo : finir
		var lImage:FlumpStateGraphic = new FlumpStateGraphic(pAssetName); // todo :pooling à penser
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		image.addChild(lImage);
		lImage.start();
	}
	
	private function addListeners ():Void {
		image = cast(SmartCheck.getChildByName(this, "Image_SelectedBuilding"), UISprite); 
		nameBuilding = cast(SmartCheck.getChildByName(this, "_text_selectedBuildingName"), TextSprite); 
		levelBuilding = cast(SmartCheck.getChildByName(this, "_text_selectedBuildingLevel"), TextSprite); 
		price = cast(SmartCheck.getChildByName(this, "_text_destroyBuildPayment"), TextSprite); 
		btnClose = cast(SmartCheck.getChildByName(this, "ButtonClose"), SmartButton);
		btnSell = cast(SmartCheck.getChildByName(this, "Button_DestroyBuildingConfirm"), SmartButton);
		btnSellText = cast(SmartCheck.getChildByName(btnSell, "Text_ConfirmCancelConstruction"), TextSprite);
		btnSellText.text = Localisation.allTraductions["LABEL_DESTROYBUILDING_BUTTON"];
		Interactive.addListenerClick(btnClose, closePoppin);
		Interactive.addListenerClick(btnSell, sellBuilding);
	}
	
	private function closePoppin():Void {
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().hideBuildingHud();
	}
	
	private function sellBuilding():Void {
		InfoBuilding.getInstance().sell();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnClose, closePoppin);
		Interactive.removeListenerClick(btnSell, sellBuilding);
		
		instance = null;
		super.destroy();
	}

}