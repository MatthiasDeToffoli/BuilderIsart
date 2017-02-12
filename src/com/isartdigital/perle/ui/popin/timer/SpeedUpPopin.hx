package com.isartdigital.perle.ui.popin.timer;

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
class SpeedUpPopin extends SmartPopinExtended
{
	
	/**
	 * instance unique de la classe SpeedUpPopin
	 */
	private static var instance: SpeedUpPopin;
	
	private static var linkedBuilding:VBuilding;
	private var btnClose:SmartButton;
	private var btnSpeedUp:SmartComponent;
	
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
	private function new(pID:String=null) 
	{
		Hud.getInstance().hide();
		super("Popin_SkipTime");	
		
		getComponents();
	}
	
	private function getComponents():Void {
		btnClose = cast(getChildByName("ButtonClose"), SmartButton);
		btnSpeedUp = cast(getChildByName("Button_SkipTimeConfirm"), SmartComponent);
		
		Interactive.addListenerClick(btnClose, onClose);
		Interactive.addListenerClick(btnSpeedUp, onBoost);
	}
	
	private function onBoost():Void {
		if (DialogueManager.ftuePlayerCanWait)
			DialogueManager.endOfaDialogue();
		BHConstruction.listTimerConstruction[linkedBuilding.tileDesc.id].boost(3000000000,true);
		destroy();
	}
	
	private function onClose():Void {
		if (DialogueManager.ftuePlayerCanWait)
			return;
		destroy();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		parent.removeChild(this);
		instance = null;
		
		super.destroy();
	}

}