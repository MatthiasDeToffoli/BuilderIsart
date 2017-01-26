package com.isartdigital.perle.ui.contextual.sprites;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.flump.Movie;
import pixi.flump.Sprite;
import pixi.interaction.EventTarget;



/**
 * Button class for all kind of Resources link to a building
 * @author COQUERELLE Killian
 */

class ButtonProduction extends SmartComponent // todo : si hérite de SmartButton il doit être un symbol btn ds le wireframe
{ 
	
	private static var assetsName:Map<GeneratorType,String>;
	
	
	// @TODO : séparer graphique du logique => VButtonProduction et ButtonProduction
	// et voir pour pooling de la partie graphique
	public function new(pType:GeneratorType) {
		super(AssetName.BTN_PRODUCTION);
		var graphic:UISprite = new UISprite(assetsName[pType]);
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, "_currency"), UISprite);
		
		graphic.position = spawner.position;
		removeChild(spawner);
		addChild(graphic);
		interactive = true;
		Interactive.addListenerClick(this, onClick);
	}
	
	public static function init(){
		assetsName = new Map<GeneratorType,String>();
		
		assetsName[GeneratorType.soft] = AssetName.PROD_ICON_SOFT;
		assetsName[GeneratorType.hard] = AssetName.PROD_ICON_HARD;
		assetsName[GeneratorType.buildResourceFromParadise] = AssetName.PROD_ICON_WOOD;
		assetsName[GeneratorType.buildResourceFromHell] = AssetName.PROD_ICON_STONE;
	}

	private function onClick ():Void {
			
	}
	
	override public function destroy():Void { // todo : destroy fonctionnel ?
		Interactive.removeListenerClick(this, onClick);
		removeAllListeners();
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}