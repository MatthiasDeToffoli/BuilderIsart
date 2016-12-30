package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;

/**
 * ...
 * @author ambroise
 */
class ConfirmBuyBuilding extends SmartPopin{

	private static var instance:ConfirmBuyBuilding;
	
	private var btnExit:SmartButton;
	private var btnBuy:SmartComponent;
	
	public static function getInstance (): ConfirmBuyBuilding {
		if (instance == null) instance = new ConfirmBuyBuilding();
		return instance;
	}	
	
	private function new() {
		super("Popin_ConfirmationBuyHouse");
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
		btnExit = cast(SmartCheck.getChildByName(this, 'Window_Infos_CloseButton'), SmartButton);
		btnBuy = cast(SmartCheck.getChildByName(this, 'Window_Infos_UpgradeButton'), SmartComponent); // todo : temp
		btnBuy.interactive = true;
		
		btnBuy.on(MouseEventType.CLICK, onClickBuy);
		btnExit.on(MouseEventType.CLICK, onClickExit);
	}
	
	private function onClickBuy ():Void {
		Phantom.onClickShop('House');
		Hud.getInstance().hideBuildingHud();
		Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}