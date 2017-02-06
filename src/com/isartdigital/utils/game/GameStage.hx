package com.isartdigital.utils.game;

import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;

/**
 * Classe en charge de mettre en place la structure graphique du jeu (conteneurs divers)
 * et la gestion du redimensionnement de la zone de jeu en fonction du contexte
 * @author Mathieu ANTHOINE
 */
class GameStage extends Container
{
	
	/**
	 * instance unique de la classe GameStage
	 */
	private static var instance: GameStage;

	private var _alignMode: GameStageAlign = GameStageAlign.CENTER;	

	private var _scaleMode: GameStageScale = GameStageScale.SHOW_ALL;
	
	private var _safeZone:Rectangle= new Rectangle(0,0,SAFE_ZONE_WIDTH,SAFE_ZONE_HEIGHT);

	/**
	 * callback de render
	 */
	private var _render:Void->Void;	
	
	/**
	 * largeur minimum pour le contenu visible par défaut
	 */
	private static inline var SAFE_ZONE_WIDTH: Int = 2048;

	/**
	 * hauteur minimum pour le contenu visible par défaut
	 */
	private static inline var SAFE_ZONE_HEIGHT: Int = 1366;
		
	/**
	 * conteneur des pop-in
	 */
	private var popinsContainer:Container;
	
	/**
	 * conteneur du Hud
	 */
	private var hudContainer:Container;
	
	/**
	 * conteneur de la FTUE
	 */
	private var ftueContainer:Container;
	
	/**
	 * conteneur des écrans d'interface
	 */
	private var screensContainer:Container;
	
	/**
	 * conteneur du jeu
	 */
	private var gameContainer:Container;
	
	private var buildContainer:Container;
	
	public function new() 
	{
		super();
				
		gameContainer = new Container();		
		addChild(gameContainer);
		
		buildContainer = new Container();
		gameContainer.addChild(buildContainer);
		
		screensContainer = new Container();
		addChild(screensContainer);
		
		hudContainer = new Container();
		addChild(hudContainer);
		
		popinsContainer = new Container();
		addChild(popinsContainer);
		
		ftueContainer = new Container();
		addChild(ftueContainer);

	}
	
	/**
	 * Initialisation de la zone de jeu
	 * @param   pRender Callback qui fait le rendu pour mettre à jour le système de coordonnées avant de reconstruire d'éventuels éléments
	 * @param	pSafeZoneWidth largeur de la safeZone
	 * @param	pSafeZoneHeight hauteur de la safeZone
	 * @param	centerGameContainer centrer ou pas le conteneur des élements InGame
	 * @param	centerScreensContainer centrer ou pas le conteneur des Ecrans
	 * @param	centerPopinContainer centrer ou pas le conteneur des Popins
	 * @param	centerHudContainer centrer ou pas le conteneur
	 */
	public function init (pRender:Void->Void, ?pSafeZoneWidth:UInt = SAFE_ZONE_WIDTH, ?pSafeZoneHeight:UInt = SAFE_ZONE_WIDTH, ?pCenterGameContainer:Bool = false, ?pCenterScreensContainer:Bool = true, ?pCenterPopinContainer:Bool = true, ?pCenterHudContainer:Bool = false, ?pCenterFtueContainer:Bool = false):Void {
		
		_safeZone = new Rectangle (0, 0, pSafeZoneWidth, pSafeZoneHeight);
		
		if (pCenterGameContainer) {
			gameContainer.x = safeZone.width / 2;
			gameContainer.y = safeZone.height / 2;
		}
		
		if (pCenterScreensContainer) {
			screensContainer.x = safeZone.width / 2;
			screensContainer.y = safeZone.height / 2;
		}
		
		if (pCenterPopinContainer) {
			popinsContainer.x = safeZone.width / 2;
			popinsContainer.y = safeZone.height / 2;
		}
		
		if (pCenterHudContainer) {
			hudContainer.x = safeZone.width / 2;
			hudContainer.y = safeZone.height / 2;
		}
		
		if (pCenterFtueContainer) {
			ftueContainer.x = safeZone.width / 2;
			ftueContainer.y = safeZone.height / 2;
		}
		
		_render = pRender;
		
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameStage {
		if (instance == null) instance = new GameStage();
		return instance;
	}
	
	/**
	 * Redimensionne la scène du jeu en fonction de la taille disponible pour l'affichage
	 */
	public function resize (): Void {
		
		var lWidth:UInt = DeviceCapabilities.width;
		var lHeight:UInt = DeviceCapabilities.height;
				
		var lRatio:Float = Math.round(10000 * Math.min( lWidth / safeZone.width, lHeight / safeZone.height)) / 10000;
		
		if (scaleMode == GameStageScale.SHOW_ALL) scale.set(lRatio, lRatio);
		else scale.set (DeviceCapabilities.textureRatio, DeviceCapabilities.textureRatio);
		
		if (alignMode == GameStageAlign.LEFT || alignMode == GameStageAlign.TOP_LEFT || alignMode == GameStageAlign.BOTTOM_LEFT) x = 0;
		else if (alignMode == GameStageAlign.RIGHT || alignMode == GameStageAlign.TOP_RIGHT || alignMode == GameStageAlign.BOTTOM_RIGHT) x = lWidth - safeZone.width * scale.x;
		else x = (lWidth - safeZone.width * scale.x) / 2;
		
		if (alignMode == GameStageAlign.TOP || alignMode == GameStageAlign.TOP_LEFT || alignMode == GameStageAlign.TOP_RIGHT) y = 0;
		else if (alignMode == GameStageAlign.BOTTOM || alignMode == GameStageAlign.BOTTOM_LEFT || alignMode == GameStageAlign.BOTTOM_RIGHT) y = lHeight - safeZone.height * scale.y;
		else y = (lHeight - safeZone.height * scale.y) / 2;
		
		
		render();
		
		emit (EventType.RESIZE, { width:lWidth, height:lHeight } );
		
	}

	/**
	 * fait le rendu de l'écran
	 */
	public function render (): Void {
		if (_render!=null) _render();
	}	
	
	/*
	 * style d'alignement au sein de l'écran
	 */
	public var alignMode (get, set) : GameStageAlign;
	
	private function get_alignMode( ) { 
		return _alignMode;
	}
	
	private function set_alignMode(pAlign:GameStageAlign) {
		_alignMode = pAlign;
		resize();
		return _alignMode;
	}

	/*
	 * style de redimensionnement au sein de l'écran
	 */
	public var scaleMode (get, set) : GameStageScale;
	
	private function get_scaleMode( ) { 
		return _scaleMode;
	}
	
	private function set_scaleMode(pScale:GameStageScale) {
		_scaleMode = pScale;
		resize();
		return _scaleMode;
	}	
	
	/**
	 * Rectangle délimitant le contenu minimum visible
	 */
	public var safeZone (get, never):Rectangle;
	
	private function get_safeZone () {
		return _safeZone;
	}

	/**
	 * accès en lecture au conteneur de jeu
	 * @return gameContainer
	 */
	public function getGameContainer (): Container {
		return gameContainer;
	}
	
	public function getBuildContainer():Container {
		return buildContainer;
	}
	/**
	 * accès en lecture au conteneur d'écrans
	 * @return screensContainer
	 */
	public function getScreensContainer (): Container {
		return screensContainer;
	}
	
	/**
	 * accès en lecture au conteneur de hud
	 * @return hudContainer
	 */
	public function getHudContainer (): Container {
		return hudContainer;
	}
	
	/**
	 * accès en lecture au conteneur de ftue
	 * @return ftueContainer
	 */
	public function getFtueContainer (): Container {
		return ftueContainer;
	}
	
	/**
	 * accès en lecture au conteneur de PopIn
	 * @return popinContainer
	 */
	public function getPopinsContainer (): Container {
		return popinsContainer;
	}
				
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy(true);
	}

}