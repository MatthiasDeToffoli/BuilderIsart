package com.isartdigital.perle;

import com.isartdigital.perle.game.GameManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import eventemitter3.EventEmitter;
import haxe.Timer;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.interaction.EventTarget;
import pixi.loaders.Loader;

/**
 * Classe d'initialisation et lancement du jeu
 * @author Ambroise RABIER
 */

class Main extends EventEmitter
{
	private static inline var FPS:UInt = 16; // Math.floor(1000/60)
	
	private static var configPath:String = "config.json";	
	private static var instance: Main;
	
	public var renderer:WebGLRenderer;
	public var stage:Container;
	
	private var frames (default, null):Int = 0;
	private var pathClass(default, null):Map<String, String> = new Map<String, String>();
	
	private static function main ():Void {
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main {
		if (instance == null) instance = new Main();
		return instance;
	}
	
	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new () {
		
		super();
		
		forceImport();
		
		var lOptions:RenderingOptions = {};
		lOptions.antialias = true;
		//lOptions.autoResize = true;
		lOptions.backgroundColor = 0x999999;
		//lOptions.resolution = 1;
		//lOptions.transparent = false;
		//lOptions.preserveDrawingBuffer (pour dataToURL)
		//cahceAsbitmap ? pour teinte par exemple
		
		DeviceCapabilities.init(); // choose Texture quality
		DeviceCapabilities.scaleViewport();
		
		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height,lOptions);
		
		//renderer.roundPixels = true;
		
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		var lConfig:Loader = new Loader();
		configPath += "?" + Date.now().getTime();
		lConfig.add(configPath);
		lConfig.once(LoadEventType.COMPLETE, preloadAssets);
		
		lConfig.load();

	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets(pLoader:Loader):Void {
		
		// initialise les paramètres de configuration
		Config.init(Reflect.field(pLoader.resources,configPath).data);
		
		// Active le mode debug
		if (Config.debug) Debug.getInstance().init();
		// défini l'alpha des Boxes de collision
		if (Config.debug && Config.data.boxAlpha != null) StateGraphic.boxAlpha = Config.data.boxAlpha;
		// défini l'alpha des anims
		if (Config.debug && Config.data.animAlpha != null) StateGraphic.animAlpha = Config.data.animAlpha;
		
		// défini le mode de redimensionnement du Jeu
		//GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL; // todo : bug si je prends ple code de mathieu ci-dessous !
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) {
			GameStage.getInstance().scaleMode = GameStageScale.NO_SCALE;
			untyped DeviceCapabilities.textureRatio = 0.5;
			untyped DeviceCapabilities.textureType = DeviceCapabilities.TEXTURE_LD;
		} else {
			GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
			DeviceCapabilities.init(1, 0.75, 0.5);
		}
		
		// initialise le GameStage et défini la taille de la safeZone
		GameStage.getInstance().init(render, 2048, 1366, true, true, true, true); // premier false => éviter le 0,0 au centre.
		
		// affiche le bouton FullScreen quand c'est nécessaire
		DeviceCapabilities.displayFullScreenButton();
		
		// Ajoute le GameStage au stage
		stage.addChild(GameStage.getInstance());
		
		// ajoute Main en tant qu'écouteur des évenements de redimensionnement
		Browser.window.addEventListener(EventType.RESIZE, resize);
		resize();
		
		// lance le chargement des assets graphiques du preloader
		/*var lLoader:GameLoader = new GameLoader(); // #reopen
		lLoader.once(LoadEventType.COMPLETE, loadAssets);
		lLoader.load();*/
		loadAssets(); // raccourci
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (/*pLoader:GameLoader*/): Void {
		var lLoader:GameLoader = new GameLoader();
				
		lLoader.addTxtFile("boxes.json");
		lLoader.addSoundFile("sounds.json");
		
		//lLoader.addAssetFile("assets.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/HellBg/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/EdenBg/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/placeholder_flump_sprite/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WireFrame_Compilation/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WireFrame_Purgatoire/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WireFrame_ListInterns/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WireFrame_Interns/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/WireFrame_Fenetre_PNJ/library.json");
		
		lLoader.addFontFile("fonts.css");
		
		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);

		// affiche l'écran de préchargement
		//UIManager.getInstance().openScreen(GraphicLoader.getInstance()); // #reopen
		
		//Browser.window.requestAnimationFrame(gameLoop);
		Timer.delay(gameLoop, FPS);
		
		lLoader.load();
		
	}
	
	/**
	 * transmet les paramètres de chargement au préchargeur graphique
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadProgress (pLoader:GameLoader): Void {
		//GraphicLoader.getInstance().update(pLoader.progress/100); // #reopen
	}
	
	/**
	 * initialisation du jeu
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadComplete (pLoader:GameLoader): Void {
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);
		// transmet à MovieClipAnimFactory la description des planches de Sprites utilisées par les anim MovieClip des instances de StateGraphic
		//MovieClipAnimFactory.addTextures(GameLoader.getContent("assets.json")); // on utilise flump maintenant.
		// transmet au StateGraphic la description des boxes de collision utilisées par les instances de StateGraphic
		//StateGraphic.addBoxes(GameLoader.getContent("boxes.json"));
		
		// Ouvre la TitleClard
		//UIManager.getInstance().openScreen(TitleCard.getInstance()); // #reopen
		
		GameManager.getInstance().start();
	}
	
	/**
	 * game loop
	 */
	private function gameLoop(/*pID:Float*/):Void {
		//Browser.window.requestAnimationFrame(gameLoop);
		Timer.delay(gameLoop, FPS);
		
		render();		
		emit(EventType.GAME_LOOP);
		
	}
	
	/**
	 * Ecouteur du redimensionnement
	 * @param	pEvent evenement de redimensionnement
	 */
	public function resize (pEvent:EventTarget = null): Void {
		renderer.resize(DeviceCapabilities.width, DeviceCapabilities.height);
		GameStage.getInstance().resize();
	}
	
	/**
	 * Return the full path for a given ClassName ("com.isart.bla.bla.Ground" for "Ground")
	 */
	public function getPath(pClassName:String):String {
		if (pathClass[pClassName] != null)
			return pathClass[pClassName];
		else
			throw "NoPath Found for Class: " + pClassName;
	}
	
	/**
	 * ForceImport of Class, and make them usable for getPath method,
	 * doesn't support two time the same ClassName whit different path !
	 * (like flump.Point and pixi.Point)
	 */
	private function forceImport() {
		var arrayClass:Array<Class<Dynamic>> = [
			Ground,
			Building
		];
		var lClassName:String;
		var lClassNameNoPath:String;
		
		for (pClass in arrayClass) {
			lClassName = Type.getClassName(pClass);
			lClassNameNoPath = lClassName.substring(lClassName.lastIndexOf(".") + 1);
			if (pathClass[lClassNameNoPath] != null)
				throw ("Conflict in pathClass whit " + lClassName);
			
			pathClass[lClassNameNoPath] = lClassName;
		}
	}
	
	/**
	 * fait le rendu de l'écran
	 */
	private function render (): Void {
		/*if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP)
			renderer.render(stage);
		else {*/ // todo supprimer commentaire :p, osef du 60fps affichage pc non ?
			if (frames++ % 2 == 0) renderer.render(stage); // dissocie rendu du calcul.
			else GameStage.getInstance().updateTransform();
		//}
	}
		
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		Browser.window.removeEventListener(EventType.RESIZE, resize);
		instance = null;
	}
	
}