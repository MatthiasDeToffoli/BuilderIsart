package com.isartdigital.perle.ui;

import com.isartdigital.utils.Config;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

/**
 * Preloader Graphique principal
 * @author Mathieu ANTHOINE
 */
class GraphicLoader extends Screen 
{
	
	/**
	 * instance unique de la classe GraphicLoader
	 */
	private static var instance: GraphicLoader;

	private var loaderBar:Sprite;

	public function new() 
	{
		super();
		var lBg:Sprite = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"preload_bg.png")));
		lBg.anchor.set(0.5, 0.5);
		addChild(lBg);
		
		loaderBar = new Sprite (Texture.fromImage(Config.url(Config.assetsPath+"preload.png")));
		loaderBar.anchor.y = 0.5;
		loaderBar.x = -loaderBar.width / 2;
		addChild(loaderBar);
		loaderBar.scale.x = 0;
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GraphicLoader {
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}
	
	/**
	 * mise à jour de la barre de chargement
	 * @param	pProgress
	 */
	public function update (pProgress:Float): Void {
		loaderBar.scale.x = pProgress;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}