package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class Cancel_Video extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe Cancel_Video
	 */
	private static var instance: Cancel_Video;
	private static var ok:SmartButton;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Cancel_Video {
		if (instance == null) instance = new Cancel_Video();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.CANCEL_AD_VIDEO);
		ok = cast(getChildByName(AssetName.CANCEL_AD_VIDEO_BTN_OK), SmartButton);
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
		Interactive.addListenerClick(ok, onClickOk);
	}
	
	private static function onClickOk():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		Interactive.removeListenerClick(ok, onClickOk);
		super.destroy();
	}

}