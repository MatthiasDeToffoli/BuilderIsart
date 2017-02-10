package com.isartdigital.perle.ui.popin.option;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author Alexis
 */
class OptionPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe OptionPoppin
	 */
	private static var instance: OptionPoppin;
	
	private static var sfxGroup:SmartComponent;
	private static var musicGroup:SmartComponent;
	private static var sfx1:SmartButton;
	private static var sfx2:SmartButton;
	private static var music1:SmartButton;
	private static var music2:SmartButton;
	
	private static var btnClose:SmartButton;
	private static var btnReset:SmartButton;
	private static var btnFR:SmartButton;
	private static var btnEN:SmartButton;
	
	private static var buttonTab:Array<Array<SmartButton>>;
	private static var musicOn:Bool = true;
	private static var sfxOn:Bool = true;

	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): OptionPoppin {
		if (instance == null) instance = new OptionPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.OPTION_POPPIN);
		setWireframe();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		SmartCheck.traceChildrens(this);
		btnClose = cast(getChildByName(AssetName.OPTION_POPPIN_CLOSE), SmartButton);
		btnReset = cast(getChildByName(AssetName.OPTION_POPPIN_RESETDATA), SmartButton);
		btnFR = cast(getChildByName(AssetName.OPTION_POPPIN_FR), SmartButton);
		btnEN = cast(getChildByName(AssetName.OPTION_POPPIN_EN), SmartButton);
		addButtonPoussoir();
		
		Interactive.addListenerClick(btnClose, onClickClose);
		Interactive.addListenerClick(btnReset, resetData);
		Interactive.addListenerClick(btnFR, onClickFr);
		Interactive.addListenerClick(btnEN, onClickEn);
	}
	
	private function addButtonPoussoir():Void {
		buttonTab = [];
		
		sfxGroup = cast(getChildByName(AssetName.OPTION_POPPIN_SFX), SmartComponent);
		buttonTab[0] = [];
		
		musicGroup = cast(getChildByName(AssetName.OPTION_POPPIN_MUSIC), SmartComponent);
		buttonTab[1] = [];
		
		sfx1 = cast(SmartCheck.getChildByName(sfxGroup, "On"), SmartButton);
		Interactive.addListenerClick(sfx1, onClickSfx);
		sfx2 = cast(SmartCheck.getChildByName(sfxGroup, "Off"), SmartButton);
		Interactive.addListenerClick(sfx2, onClickSfx);
		buttonTab[0].push(sfx1);
		buttonTab[0].push(sfx2);
		
		music1 = cast(SmartCheck.getChildByName(musicGroup, "On"), SmartButton);
		Interactive.addListenerClick(music1, onClickMusic);
		music2 = cast(SmartCheck.getChildByName(musicGroup, "Off"), SmartButton);
		Interactive.addListenerClick(music2, onClickMusic);
		buttonTab[1].push(music1);
		buttonTab[1].push(music2);
	}
	
	private function setButtons(pNumber:Int):Void {
		buttonTab[pNumber][0].visible? buttonTab[pNumber][0].visible = false: buttonTab[pNumber][0].visible = true;
	}
	
	private function onClickSfx():Void {
		setButtons(0);
		sfxOn = checkOnOff(sfxOn);
		checkSfx(sfxOn);
	}
	
	private function onClickMusic():Void {
		setButtons(1);
		musicOn = checkOnOff(musicOn);
		checkMusic(musicOn);
	}
	
	private function checkOnOff(pSound):Bool {
		pSound? return false: return true;
	}
	
	private function checkSfx(pSfx):Void {
		pSfx? trace("SFX ON"): trace("SFX OFF");
	}
	
	private function checkMusic(pMusic):Void {
		pMusic? trace("MUSIC ON"): trace("MUSIC OFF");
	}
	
	private function onClickFr():Void {
		trace("FR");
	}
	
	private function onClickEn():Void {
		trace("EN");
	}
	
	private function onClickClose():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function resetData():Void {
		UIManager.getInstance().openPopin(ResetDataPoppin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnClose, onClickClose);
		Interactive.removeListenerClick(btnReset, resetData);
		Interactive.removeListenerClick(sfx1, onClickSfx);
		Interactive.removeListenerClick(sfx2, onClickSfx);
		Interactive.removeListenerClick(music1, onClickMusic);
		Interactive.removeListenerClick(music2, onClickMusic);
		
		Interactive.removeListenerClick(btnFR, onClickFr);
		Interactive.removeListenerClick(btnEN, onClickEn);
		instance = null;
	}

}