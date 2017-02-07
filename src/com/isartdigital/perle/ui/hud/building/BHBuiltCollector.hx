package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.popin.collector.CollectorPopin;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltCollector extends BHBuiltUpgrade 
{
	
	/**
	 * instance unique de la classe BHBuiltCollector
	 */
	private static var instance: BHBuiltCollector;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BHBuiltCollector {
		if (instance == null) instance = new BHBuiltCollector();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.CONTEXTUAL_COLLECTOR);
		
	}
	
	override function openInfoBuilding():Void 
	{
		UIManager.getInstance().openPopin(CollectorPopin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}