package com.isartdigital.perle.ui;

import com.isartdigital.perle.ui.gauge.LoadingBar;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
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
	private var loadingBar:LoadingBar;
	private var loaderBar_bar:UISprite;

	public function new() 
	{
		super();
		loadingBar = new LoadingBar();
		addChild(loadingBar);
		loadingBar.scale.x *= 2;
		loadingBar.scale.y *= 2;
		
		var lBg:UISprite = cast(SmartCheck.getChildByName(loadingBar, "loading_fond"), UISprite);
		loaderBar_bar = cast(SmartCheck.getChildByName(loadingBar, "loading_barre"), UISprite);
		var lMasque:UISprite = new UISprite("loading_masque");
		lMasque.scale.x *= 2;
		lMasque.scale.y *= 3;
		lMasque.x = loadingBar.x - loadingBar.width/2 - lMasque.width/4;
		addChild(lMasque);
		loaderBar_bar.x = loadingBar.x - loadingBar.width / 16 ;
		loaderBar_bar.scale.x = 0;
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
		loaderBar_bar.scale.x = pProgress;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}