package com.isartdigital.perle.ui.popin.option;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.ui.popin.credits.CreditPoppin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

	
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
	private static var btnOption:SmartButton;
	
	private static var languageText:TextSprite;
	private static var soundText:TextSprite;
	private static var datasText:TextSprite;
	
	private static var sfx1Text:Dynamic;
	private static var sfx2Text:TextSprite;
	private static var music1Text:TextSprite;
	private static var music2Text:TextSprite;
	private static var btnResetText:TextSprite;
	
	
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
		setValues();
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		btnClose = cast(getChildByName(AssetName.OPTION_POPPIN_CLOSE), SmartButton);
		btnReset = cast(getChildByName(AssetName.OPTION_POPPIN_RESETDATA), SmartButton);
		btnFR = cast(getChildByName(AssetName.OPTION_POPPIN_FR), SmartButton);
		btnEN = cast(getChildByName(AssetName.OPTION_POPPIN_EN), SmartButton);
		btnOption = cast(getChildByName(AssetName.OPTION_CREDITS), SmartButton);
		
		languageText = cast(getChildByName(AssetName.OPTION_POPPIN_LANGUAGE_TEXT), TextSprite);
		soundText = cast(getChildByName(AssetName.OPTION_POPPIN_SOUND_TEXT), TextSprite);
		datasText = cast(getChildByName(AssetName.OPTION_POPPIN_DATAS_TEXT), TextSprite);
		
		btnResetText = cast(SmartCheck.getChildByName(btnReset, AssetName.OPTION_POPPIN_DATAS_BTN_TEXT), TextSprite);
		addButtonPoussoir();
		if (!musicOn)
			setButtons(1);
		if (!sfxOn)
			setButtons(0);
		
		Interactive.addListenerClick(btnClose, onClickClose);
		Interactive.addListenerClick(btnReset, resetData);
		Interactive.addListenerRewrite(btnReset, setValuesBtnReset);
		Interactive.addListenerClick(btnFR, onClickFr);
		Interactive.addListenerClick(btnEN, onClickEn);
		Interactive.addListenerClick(btnOption, openOptionPoppin);
	}
	
	private function addButtonPoussoir():Void {
		buttonTab = [];
		
		sfxGroup = cast(getChildByName(AssetName.OPTION_POPPIN_SFX), SmartComponent);
		buttonTab[0] = [];
		
		musicGroup = cast(getChildByName(AssetName.OPTION_POPPIN_MUSIC), SmartComponent);
		buttonTab[1] = [];
		
		sfx1 = cast(SmartCheck.getChildByName(sfxGroup, "On"), SmartButton);
		sfx1Text = SmartCheck.getChildByName(sfx1, AssetName.OPTION_POPPIN_SFX_ON);
		
		Interactive.addListenerClick(sfx1, onClickSfx);
		
		sfx2 = cast(SmartCheck.getChildByName(sfxGroup, "Off"), SmartButton);
		//sfx2Text = cast(SmartCheck.getChildByName(sfx2, AssetName.OPTION_POPPIN_SFX_OFF_TEXT), TextSprite);
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
	
	private function openOptionPoppin():Void {
		//UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(CreditPoppin.getInstance());
	}
	
	private function setButtons(pNumber:Int):Void {
		buttonTab[pNumber][0].visible? buttonTab[pNumber][0].visible = false: buttonTab[pNumber][0].visible = true;
	}
	
	private function setValues():Void{
		languageText.text =  Localisation.getText("LABEL_OPTIONS_LANGAGE_TITLE");
		soundText.text =  Localisation.getText("LABEL_LEVEL_OPTIONS_SOUND_TITLE");
		datasText.text =  Localisation.getText("LABEL_OPTIONS_RESET_DATA");
		
		setValuesBtnReset();
	}
	
	private function setValuesBtnReset():Void{
		btnResetText = cast(SmartCheck.getChildByName(btnReset, AssetName.OPTION_POPPIN_DATAS_BTN_TEXT), TextSprite);
		btnResetText.text = Localisation.getText("LABEL_OPTIONS_RESET_DATA");
	}
	
	private function onClickSfx():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		setButtons(0);
		sfxOn = checkOnOff(sfxOn);
		checkSfx(sfxOn);
	}
	
	private function onClickMusic():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		setButtons(1);
		musicOn = checkOnOff(musicOn);
		checkMusic(musicOn);
	}
	
	private function checkOnOff(pSound):Bool {
		pSound? return false: return true;
	}
	
	private function checkSfx(pSfx):Void {
		pSfx? SoundManager.isMute = false : SoundManager.isMute = true;
	}
	
	private function checkMusic(pMusic):Void {
		pMusic? SoundManager.getSound("MUSIC_MAIN").play() : SoundManager.getSound("MUSIC_MAIN").stop();
	}
	
	private function onClickFr():Void {
		DialogueManager.isFR = true;
		DialogueManager.changeLanguage();
		SoundManager.getSound("SOUND_NEUTRAL").play();
		Localisation.traduction("fr");
		actualizePopin();
	}
	
	private function onClickEn():Void {
		DialogueManager.isFR = false;
		DialogueManager.changeLanguage();
		SoundManager.getSound("SOUND_NEUTRAL").play();
		Localisation.traduction("en");
		actualizePopin();
	}
	
	private function onClickClose():Void {
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function resetData():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		UIManager.getInstance().openPopin(ResetDataPoppin.getInstance());
	}
	
	private static function actualizePopin():Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(OptionPoppin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnClose, onClickClose);
		Interactive.removeListenerClick(btnReset, resetData);
		Interactive.removeListenerRewrite(btnReset, setValuesBtnReset);
		Interactive.removeListenerClick(sfx1, onClickSfx);
		Interactive.removeListenerClick(sfx2, onClickSfx);
		Interactive.removeListenerClick(music1, onClickMusic);
		Interactive.removeListenerClick(music2, onClickMusic);
		
		Interactive.removeListenerClick(btnFR, onClickFr);
		Interactive.removeListenerClick(btnEN, onClickEn);
		Interactive.removeListenerClick(btnOption, openOptionPoppin);
		instance = null;
	}

}