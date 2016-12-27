package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.ExperienceManager;
import com.isartdigital.perle.game.managers.FtueManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.contextual.HudContextual;


import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.CheatPanel;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import pixi.interaction.EventTarget;

/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager {
	private static var instance: GameManager;
	
	public static function getInstance (): GameManager {
		if (instance == null) instance = new GameManager();
		return instance;
	}
	
	private function new() {
		
	}
	
	public function start (): Void {
		// todo : deplacer les init class faisant rien de 
		// plus que des new() ds le main
		
		BuyManager.initClass();
		ExperienceManager.setExpToLevelUp();// always before SaveManager
		UIManager.getInstance().startGame();	
		PoolingManager.init();
		HudContextual.initClass();
		CameraManager.setTarget(GameStage.getInstance().getGameContainer());
		TimeManager.initClass();
		VTile.initClass();
		Tile.initClass();
		HudContextual.addContainer();
		Phantom.initClass();
		RegionManager.init();
		SaveManager.createFromSave();
		UnlockManager.setUnlockItem();
		ClippingManager.update();
		
		
		FtueManager.createFtue();
		CheatPanel.getInstance().ingame();
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
	}
	
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public function gameLoop (pEvent:EventTarget): Void {
		// le renderer possède une propriété plugins qui contient une propriété interaction de type InteractionManager
		// les instances d'InteractionManager fournissent un certain nombre d'informations comme les coordonnées globales de la souris
		// IMPORTANT :  cast(Main.getInstance().renderer.plugins.interaction, InteractionManager).mouse.global) coordonnées de la souris en global
		//if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) trace (CollisionManager.hitTestPoint(Template.getInstance().hitBox, cast(Main.getInstance().renderer.plugins.interaction, InteractionManager).mouse.global));
	
		// todo : doublon mousePos X,y
		
		MouseManager.getInstance().gameLoop();
		Phantom.gameLoop();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		MouseManager.getInstance().destroy();
		Main.getInstance().off(EventType.GAME_LOOP,gameLoop);
		instance = null;
	}

}