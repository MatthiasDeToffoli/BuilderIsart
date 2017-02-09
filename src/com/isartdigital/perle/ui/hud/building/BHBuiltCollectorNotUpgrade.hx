package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltCollectorNotUpgrade extends BHBuiltCollector
{
	
	/**
	 * instance unique de la classe BHBuiltCollectorNotUpgrade
	 */
	private static var instance: BHBuiltCollectorNotUpgrade;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHBuiltCollectorNotUpgrade {
		if (instance == null) instance = new BHBuiltCollectorNotUpgrade();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.CONTEXTUAL_COLLECTOR_NOT_UPGRADABLE);
		
	}
	
	override function haveUpgradeBtn():Bool 
	{
		return false;
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}