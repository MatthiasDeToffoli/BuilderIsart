package com.isartdigital.perle.ui.popin.marketing;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class MarketingPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe MarketingPopin
	 */
	private static var instance: MarketingPopin;
	private var btnClose:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MarketingPopin {
		if (instance == null) instance = new MarketingPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.MARKETING_POPIN);
		
		//SmartCheck.traceChildrens(this);
		btnClose = cast(SmartCheck.getChildByName(this, AssetName.BTN_CLOSE),SmartButton);
		
		Interactive.addListenerClick(btnClose,onClose);
	}
	
	private function onClose():Void {
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}