package com.isartdigital.perle.ui.popin;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author ambroise
 */
class InfoBuilding extends SmartPopin {
	
	/**
	 * instance unique de la classe InfoBuilding
	 */
	private static var instance: InfoBuilding;
	
	private var btnExit:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): InfoBuilding {
		if (instance == null) instance = new InfoBuilding();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super("Fenetre_InfoMaison");
		
		for (i in 0...children.length) // cheat pratique
			trace (children[i].name);
			
		btnExit = cast(getChildByName('CloseButton'), SmartButton);
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}