package com.isartdigital.perle.ui.popin;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author COQUERELLE Killian
 */
class DailyRewardPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe DailyRewardPopin
	 */
	private static var instance: DailyRewardPopin;
	
	private var btnClose:SmartButton;
	private var btnGain:SmartButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DailyRewardPopin {
		if (instance == null) instance = new DailyRewardPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.DAILY_REWARDS_POPPIN);
	}
	
	private function setButtonsAndAddListeners():Void{
		
		btnClose = cast(SmartCheck.getChildByName(this, AssetName.BTN_CLOSE), SmartButton);
		btnGain = cast(SmartCheck.getChildByName(this, AssetName.DAILY_REWARD_POPIN_GAIN_BUTTON), SmartButton);
		
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onClose() {
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}