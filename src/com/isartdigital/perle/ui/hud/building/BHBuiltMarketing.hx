package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.ui.popin.marketing.MarketingPopin;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltMarketing extends BHBuiltProductor
{

	/**
	 * instance unique de la classe BHBuiltCollector
	 */
	private static var instance: BHBuiltMarketing;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHBuiltMarketing{
		if (instance == null) instance = new BHBuiltMarketing();
		return instance;
	}
	
	public function new() 
	{
		super(AssetName.CONTEXTUAL_MARKETING);
		
	}
	
	override function testIfProduct():Bool 
	{
		return MarketingManager.isInCampaign();
	}
	
	override function openInfoBuilding():Void 
	{
		UIManager.getInstance().openPopin(MarketingPopin.getInstance());
		Hud.getInstance().hide();
	}
	override function createTimer():Void 
	{
		timer = new BuildingTimerMarketing();
		timer.spawn();
		Hud.getInstance().addSecondaryComponent(timer);
	}
	
	override function haveUpgradeBtn():Bool 
	{
		return false;
	}
	
	override public function destroy():Void 
	{
		instance = null;
		super.destroy();
	}
	
}