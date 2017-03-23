package com.isartdigital.perle.ui.popin.onLaunch;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.Browser;

	
/**
 * ...
 * @author Rafired
 */
class OnLaunchPoppin extends SmartPopinExtended 
{
	private var closeButton:SmartButton;
	private var continueButton:SmartButton;
	private var yeldizButton:SmartButton;
	private var monsterButton:SmartButton;
	private var bloomButton:SmartButton;
	private var isartButton:SmartButton;
	private var text1:TextSprite;
	private var text2:TextSprite;
	private var FACEBOOK_APP_LINK(default, never):String = 'https://apps.facebook.com/';
	private var YELDIZ(default, never):String = 'yeldizthegame';
	private var MONSTER_HAVEN(default, never):String = '';
	private var BLOOMING_SKY(default, never):String = 'blooming_sky';
	private var ISART_LINK(default, never):String = 'LABEL_LINK_ISART';
	private var TEXT1(default, never):String = 'LABEL_POPIN_LUNCH_TEXT1';
	private var TEXT2(default, never):String = 'LABEL_POPIN_LUNCH_TEXT2';
	private var TEXT_BUTTON_CONTINUE(default, never):String = 'LABEL_POPIN_LUNCH_TEXT_BUTTON_CONTINUE';
	
	/**
	 * instance unique de la classe OnLaunchPoppin
	 */
	private static var instance: OnLaunchPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): OnLaunchPoppin {
		if (instance == null) instance = new OnLaunchPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.ONLAUNCH_POPPIN);
		closeButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_CLOSE), SmartButton);
		continueButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_CONTINUE), SmartButton);
		yeldizButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_YELDIZ), SmartButton);
		monsterButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_MONSTERHAVEN), SmartButton);
		bloomButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_BLOOMINGSKY), SmartButton);
		isartButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_ISART), SmartButton);
		text1 = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_TEXT1), TextSprite);
		text2 = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_TEXT2), TextSprite);
		
		text1.text = Localisation.getText(TEXT1);
		text2.text = Localisation.getText(TEXT2);
		Interactive.addListenerClick(closeButton, closeThisPoppin);
		Interactive.addListenerClick(continueButton, closeThisPoppin);
		Interactive.addListenerClick(yeldizButton, openYeldiz);
		Interactive.addListenerClick(monsterButton, openMonster);
		Interactive.addListenerClick(bloomButton, openBlooming);
		Interactive.addListenerClick(isartButton, openIsart);
		
		Interactive.addListenerRewrite(continueButton, rewriteContinueButton);
		rewriteContinueButton();
	}
	
	private function rewriteContinueButton() {
		var txt:TextSprite = cast(continueButton.getChildByName(AssetName.ONLAUNCH_POPPIN_TEXT_BUTTON_CONTINUE), TextSprite);
		
		txt.text = Localisation.getText(TEXT_BUTTON_CONTINUE);
	}
	
	private function closeThisPoppin():Void {
		DialogueManager.closeFirstPoppin();
	}
	
	private function openYeldiz():Void {
		Browser.window.open(FACEBOOK_APP_LINK + YELDIZ);
	}
	
	private function openMonster():Void {
		Browser.window.open(FACEBOOK_APP_LINK + MONSTER_HAVEN);
	}
	
	private function openBlooming():Void {
		Browser.window.open(FACEBOOK_APP_LINK + BLOOMING_SKY);
	}
	
	private function openIsart():Void {
		Browser.window.open(Localisation.getText(ISART_LINK));
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerRewrite(continueButton, rewriteContinueButton);
		Interactive.removeListenerClick(closeButton, closeThisPoppin);
		Interactive.removeListenerClick(continueButton, closeThisPoppin);
		Interactive.removeListenerClick(yeldizButton, openYeldiz);
		Interactive.removeListenerClick(monsterButton, openMonster);
		Interactive.removeListenerClick(bloomButton, openBlooming);
		Interactive.removeListenerClick(isartButton, openIsart);
		
		instance = null;
	}

}