package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.popin.collector.CollectorPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltCollectorUpgradable extends BHBuiltUpgrade 
{
	
	/**
	 * instance unique de la classe BHBuiltCollector
	 */
	private static var instance: BHBuiltCollectorUpgradable;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHBuiltCollectorUpgradable {
		if (instance == null) instance = new BHBuiltCollectorUpgradable();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.CONTEXTUAL_COLLECTOR);
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}