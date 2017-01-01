package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
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
	private var btnSell:SmartButton;
	
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
			
		btnExit = cast(getChildByName('CloseButton'), SmartButton);
		btnSell = cast(getChildByName('SellButton'), SmartButton);
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnSell.on(MouseEventType.CLICK, onClickSell);
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickSell ():Void {
		BuyManager.sell(cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName());
		UIManager.getInstance().closeCurrentPopin();
		BuildingHud.virtualBuilding.destroy();
		Hud.getInstance().hideBuildingHud();
		SaveManager.save();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}