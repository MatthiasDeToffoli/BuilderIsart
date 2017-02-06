package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager.Population;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.utils.ui.UIPosition;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

	
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
	private var soulConter:SoulCounterHouse;
	private var soulGraphic:UISprite;
	
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
		
		addSoulCounter();
		
	}
	
	public function addSoulCounter():Void {
		soulConter = new SoulCounterHouse();
		Hud.getInstance().addSoulCounter(soulConter);
		soulConter.position.x += BuildingHud.virtualBuilding.graphic.getLocalBounds().width / 2;
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		soulConter.destroy();
		super.destroy();
	}

}