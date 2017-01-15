package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager.Population;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BHHarvestHouse extends BHBuilt 
{
	
	/**
	 * instance unique de la classe BHHarvestHouse
	 */
	private static var instance: BHHarvestHouse;
	private var soulConters:TextSprite;
	private var soulGraphic:UISprite;
	private var spawner:UISprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHHarvestHouse {
		if (instance == null) instance = new BHHarvestHouse();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super("BuiltContext_house");
		
		
	}
	
	override function addListeners():Void 
	{
		soulConters = cast(SmartCheck.getChildByName(SmartCheck.getChildByName(this, "SoulsCounter_House"), "_infos_house_txt"), TextSprite);
		super.addListeners();
	}
	
	override public function setOnSpawn():Void 
	{
		super.setOnSpawn();
		var pPop:Population = cast(BuildingHud.virtualBuilding, VHouse).getPopulation();
		soulConters.text = pPop.quantity + "/" + pPop.max;
		
		if( spawner == null) spawner = cast(
				SmartCheck.getChildByName(
					SmartCheck.getChildByName(this, "SoulsCounter_House"), 
					"_infos_house_icon")
		,UISprite);
		
		var aName:String = "";
		
		if (BuildingHud.virtualBuilding.alignementBuilding == Alignment.heaven) aName = AssetName.PROD_ICON_SOUL_HEAVEN_SMALL;
		else aName = AssetName.PROD_ICON_SOUL_HELL_SMALL;
		soulGraphic = new UISprite(aName);
		soulGraphic.position = spawner.position;
		addChild(soulGraphic);
		spawner.parent.removeChild(spawner);
	}
	
	override function removeButtonsChange():Void 
	{
		addChild(spawner);
		removeChild(soulGraphic);
		super.removeButtonsChange();
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		
		super.destroy();
	}

}