package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.BoostManager;
import com.isartdigital.perle.game.managers.BuildingLimitManager;
import com.isartdigital.perle.game.managers.CameraManager;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.CocoonJSManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ExperienceManager;
import com.isartdigital.perle.game.managers.MarketingManager;
import com.isartdigital.perle.game.managers.MouseManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.FootPrint;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.CheatPanel;
import com.isartdigital.perle.ui.contextual.HudContextual;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProduction;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
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

		
		if (DeviceCapabilities.isCocoonJS)
			CocoonJSManager.awake();
		

		BuildingLimitManager.awake();
		MarketingManager.awake(); // always before VTile
		BoostManager.awake(); //always before pooling
		ButtonProduction.init(); //always before pooling
		Tile.initClass();//always before pooling manager
		ServerManager.playerConnexion();
		GameConfig.awake();
		Intern.init(); //Always before RegionManager
		//ServerManager.refreshConfig(); // todo : remplacer par cron ?
		ResourcesManager.awake(); // akways befire all ui init
		ExperienceManager.setExpToLevelUp();// always before SaveManager
		UIManager.getInstance().startGame();	
		PoolingManager.init();
		HudContextual.initClass();
		CameraManager.setTarget(GameStage.getInstance().getGameContainer());
		TimeManager.initClass();
		VTile.initClass();
		HudContextual.addContainer();
		Phantom.initClass();
		RegionManager.init();
		//Choice.init(); //Todo: en attendant mieux
		SaveManager.createFromSave();
		//UnlockManager.setUnlockItem();
		ClippingManager.update();
		FootPrint.startClass();
		ChoiceManager.init();
		
		DialogueManager.createFtue();
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
		
		
		MouseManager.getInstance().gameLoop(); // before Phantom
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