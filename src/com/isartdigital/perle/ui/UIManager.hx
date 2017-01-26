package com.isartdigital.perle.ui;

import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.FocusManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.Screen;
import pixi.core.display.Container;

/**
 * Manager (Singleton) en charge de gérer les écrans d'interface
 * @author Mathieu ANTHOINE
 */
class UIManager 
{
	
	/**
	 * instance unique de la classe UIManager
	 */
	private static var instance: UIManager;
	
	
	/**
	 * tableau des popins ouverts
	 */
	private var popins:Array<Popin>;

	public function new() 
	{
		popins = [];
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): UIManager {
		if (instance == null) instance = new UIManager();
		return instance;
	}
	
	/**
	 * Ajoute un écran dans le conteneur de Screens en s'assurant qu'il n'y en a pas d'autres
	 * @param	pScreen Screen à ouvrir
	 */
	public function openScreen (pScreen: Screen): Void {
		closeScreens();
		GameStage.getInstance().getScreensContainer().addChild(pScreen);
		pScreen.open();
	}
	
	/**
	 * Supprime les écrans dans le conteneur de Screens
	 */
	public function closeScreens (): Void {
		var lContainer:Container = GameStage.getInstance().getScreensContainer();
		while (lContainer.children.length > 0) {
			var lCurrent:Screen = cast(lContainer.getChildAt(lContainer.children.length - 1), Screen);
			lCurrent.interactive = false;
			lContainer.removeChild(lCurrent);
			lCurrent.close();
		}
	}
	
	/**
	 * Ajoute un popin dans le conteneur de Popin
	 * @param	pPopin Popin à ouvrir
	 */
	public function openPopin (pPopin: Popin): Void {
		popins.push(pPopin);
		GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
	}
	
	/**
	 * Supprime le popin dans le conteneur de Screens
	 */
	public function closeCurrentPopin (): Void {
		if (popins.length == 0) return;
		var lCurrent:Popin = popins.pop();
		lCurrent.interactive = false;
		GameStage.getInstance().getPopinsContainer().removeChild(lCurrent);
		lCurrent.close();
		
	}
	
	/**
	 * Ajoute le hud dans le conteneur de Hud
	 */
	public function openHud (): Void {
		GameStage.getInstance().getHudContainer().addChild(Hud.getInstance());
		Hud.getInstance().open();
	}
	
	/**
	 * Retire le hud du conteneur de Hud
	 */
	public function closeHud (): Void {
		GameStage.getInstance().getHudContainer().removeChild(Hud.getInstance());
		Hud.getInstance().close();
	}
	
		/**
	 * Ajoute le hud dans le conteneur de Hud
	 */
	public function openFTUE (): Void {
		GameStage.getInstance().getHudContainer().addChild(FocusManager.getInstance());
		FocusManager.getInstance().open();
	}
	
	/**
	 * Retire le hud du conteneur de Hud
	 */
	public function closeFTUE (): Void {
		GameStage.getInstance().getHudContainer().removeChild(FocusManager.getInstance());
		FocusManager.getInstance().close();
	}
	
	/**
	 * met l'interface en mode jeu
	 */
	 public function startGame (): Void {
		closeScreens();
		openHud();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}