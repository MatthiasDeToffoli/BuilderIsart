package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.utils.events.MouseEventType;
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
		
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = InfoBuilding.getVirtualBuilding();
		
		trace(BuildingHud.virtualBuilding);
		trace(InfoBuilding.getVirtualBuilding());
		
		nameBuilding.text = FakeTraduction.assetNameNameToTrad(lVBuilding.getAsset());
		
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade))
			levelBuilding.text = "Level : " + Std.string(cast(lVBuilding, VBuildingUpgrade).indexLevel + 1);
		else levelBuilding.text = "";
		
		setImage(lVBuilding.getAsset());
		price.text = ""+ BuyManager.getSellPrice(lVBuilding.getAsset()); 
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
		
		cast(SmartCheck.getChildByName(this, "ButtonClose"), SmartButton).on(MouseEventType.CLICK, closePoppin);
		cast(SmartCheck.getChildByName(this, "Button_DestroyBuildingConfirm"), SmartButton).on(MouseEventType.CLICK, sellBuilding);
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
		instance = null;
		super.destroy();
	}

}