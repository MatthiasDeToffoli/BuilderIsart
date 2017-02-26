package com.isartdigital.perle.ui.popin.accelerate;

import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
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
		price = Math.ceil((linkedBuilding.tileDesc.timeDesc.end - linkedBuilding.tileDesc.timeDesc.progress) / AcceleratePopin.TIME_BASE_PRICE);
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
		super();
	}
	
	override private function onAccelerate():Void {
		rewriteBtn();
		SoundManager.getSound("SOUND_KARMA").play();
		if (DialogueManager.ftuePlayerCanWait)
			DialogueManager.endOfaDialogue();
			
		if (ResourcesManager.getTotalForType(GeneratorType.hard) - price < 0) return;
		ServerManagerBuilding.BoostBuilding(linkedBuilding.tileDesc);
	}
	
	public function validBoost():Void {
		BHConstruction.listTimerConstruction[linkedBuilding.tileDesc.id].boost();
		
		var arrayForChange:Map<String, Dynamic> = ["type" => BuildingHudType.HARVEST, "building" => linkedBuilding];
		Hud.eChangeBH.emit(Hud.EVENT_CHANGE_BUIDINGHUD, arrayForChange);
		
		linkedBuilding.alignementBuilding == Alignment.heaven ? SoundManager.getSound("SOUND_FINISH_BUILDING_HEAVEN").play() : SoundManager.getSound("SOUND_FINISH_BUILDING_HELL").play();
		Hud.getInstance().show();
		onClose();
	}
	
	override private function onClose():Void {
		if (DialogueManager.ftuePlayerCanWait)
			return;
			
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		Hud.getInstance().show();
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