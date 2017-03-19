package com.isartdigital.perle.ui.popin.onLaunch;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

	
/**
 * ...
 * @author Rafired
 */
class OnLaunchPoppin extends SmartPopinExtended 
{
	private var closeButton:SmartButton;
	private var continueButton:SmartButton;
	private var canimButton:SmartButton;
	private var yeldizButton:SmartButton;
	private var depthsButton:SmartButton;
	private var monsterButton:SmartButton;
	private var bloomButton:SmartButton;
	
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
		canimButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_CANIMPERIUM), SmartButton);
		yeldizButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_YELDIZ), SmartButton);
		depthsButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_DEPTHS), SmartButton);
		monsterButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_MONSTERHAVEN), SmartButton);
		bloomButton = cast(getChildByName(AssetName.ONLAUNCH_POPPIN_BLOOMINGSKY), SmartButton);
		
		Interactive.addListenerClick(closeButton, closeThisPoppin);
		Interactive.addListenerClick(continueButton, closeThisPoppin);
		Interactive.addListenerClick(canimButton, openCanim);
		Interactive.addListenerClick(yeldizButton, openYeldiz);
		Interactive.addListenerClick(depthsButton, openDepths);
		Interactive.addListenerClick(monsterButton, openMonster);
		Interactive.addListenerClick(bloomButton, openBlooming);
	}
	
	private function closeThisPoppin():Void {
		DialogueManager.closeFirstPoppin();
	}
	
	private function openCanim():Void {
		trace("on perds un joueur pour canim");
	}
	
	private function openYeldiz():Void {
		trace("on perds un joueur pour yeldiz");
	}
	
	private function openDepths():Void {
		trace("on perds un joueur pour depths");
	}
	
	private function openMonster():Void {
		trace("on perds un joueur pour monster");
	}
	
	private function openBlooming():Void {
		trace("on perds un joueur pour blooming");
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(closeButton, closeThisPoppin);
		Interactive.removeListenerClick(continueButton, closeThisPoppin);
		Interactive.removeListenerClick(canimButton, openCanim);
		Interactive.removeListenerClick(yeldizButton, openYeldiz);
		Interactive.removeListenerClick(depthsButton, openDepths);
		Interactive.removeListenerClick(monsterButton, openMonster);
		Interactive.removeListenerClick(bloomButton, openBlooming);
		
		instance = null;
	}

}