package com.isartdigital.perle.ui;
import com.isartdigital.utils.Config;
import dat.gui.GUI;
import com.isartdigital.utils.system.DeviceCapabilities;

	
/**
 * Classe permettant de manipuler des parametres du projet au runtime
 * Si la propriété Config.debug et à false ou que la propriété Config.data.cheat est à false, aucun code n'est executé.
 * Il n'est pas nécessaire de retirer ou commenter le code du CheatPanel dans la version "release" du jeu
 * @author Mathieu ANTHOINE
 */
class CheatPanel 
{
	
	/**
	 * instance unique de la classe CheatPanel
	 */
	private static var instance: CheatPanel;
	
	/**
	 * instance de dat.GUI composée par le CheatPanel
	 */
	private var gui:GUI;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CheatPanel {
		if (instance == null) instance = new CheatPanel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		init();
	}
	
	private function init():Void {
		if (Config.debug && Config.data.cheat && !DeviceCapabilities.isCanvasPlus) gui = new GUI();
	}
	
	// exemple de méthode configurant le panneau de cheat suivant le contexte
	public function ingame (): Void {
		// ATTENTION: toujours intégrer cette ligne dans chacune de vos méthodes pour ignorer le reste du code si le CheatPanel doit être désactivé
		if (gui == null) return;
		
		
		//gui.add(Template.getInstance(), "x", -1000, 1000).listen();
		//gui.add(Template.getInstance(), "y", -500, 500).listen();		
	}
	
	/**
	 * vide le CheatPanel
	 */
	public function clear ():Void {
		if (gui == null) return;
		gui.destroy();
		init();
	}	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}