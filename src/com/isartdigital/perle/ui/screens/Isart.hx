package com.isartdigital.perle.ui.screens;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class Isart extends Screen 
{
	
	/**
	 * instance unique de la classe Isart
	 */
	private static var instance: Isart;
	private var background:Sprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Isart {
		if (instance == null) instance = new Isart();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+ Main.LOGO_FOLDER + DeviceCapabilities.textureType + '/' + AssetName.LOGO_ISART)));
		background.anchor.set(0.5, 0.5);
		addChild(background);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}