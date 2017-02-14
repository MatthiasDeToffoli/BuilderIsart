package com.isartdigital.perle.ui.popin.accelerate;

import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
	
/**
 * ...
 * @author grenu
 */
class SpeedUpPopin extends AcceleratePopin
{
	
	/**
	 * instance unique de la classe SpeedUpPopin
	 */
	private static var instance: SpeedUpPopin;
	private static var linkedBuilding:VBuilding;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SpeedUpPopin {
		if (instance == null) instance = new SpeedUpPopin();
		return instance;
	}
	
	public static function linkBuilding(build:VBuilding):Void {
		linkedBuilding = build;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();	
	}
	
	override private function onAccelerate():Void {
		if (DialogueManager.ftuePlayerCanWait)
			DialogueManager.endOfaDialogue();
		
		BHConstruction.listTimerConstruction[linkedBuilding.tileDesc.id].boost(300000, true);
		onClose();
	}
	
	override private function onClose():Void {
		if (DialogueManager.ftuePlayerCanWait)
			return;
		
		super.onClose();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}