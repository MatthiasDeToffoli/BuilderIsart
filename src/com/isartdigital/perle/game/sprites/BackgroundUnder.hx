package com.isartdigital.perle.game.sprites;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class BackgroundUnder extends FlumpStateGraphic 
{
	
	/**
	 * instance unique de la classe BackgroundUnder
	 */
	private static var instance: BackgroundUnder;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): BackgroundUnder {
		if (instance == null) instance = new BackgroundUnder();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.BACKGROUND_UNDER);
		
	}
	
	override public function init():Void 
	{
		super.init();
		trace(width);
		position.x -= width / 5;
		position.y -= height / 5;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}