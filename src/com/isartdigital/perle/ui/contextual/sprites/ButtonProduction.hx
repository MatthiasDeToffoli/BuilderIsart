package com.isartdigital.perle.ui.contextual.sprites;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.perle.game.managers.ValueChangeManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;



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
		Interactive.addListenerClick(this, DialogueManager.recoltStepOver);
		//on(EventType.ADDED, registerForFTUE);
	}
	
	public static function init(){
		assetsName = new Map<GeneratorType,String>();
		assetsName[GeneratorType.soft] = AssetName.PROD_ICON_SOFT;
		assetsName[GeneratorType.hard] = AssetName.PROD_ICON_HARD;
		assetsName[GeneratorType.buildResourceFromParadise] = AssetName.PROD_ICON_WOOD;
		assetsName[GeneratorType.buildResourceFromHell] = AssetName.PROD_ICON_STONE;
	}

	private function onClick ():Void {
		TweenManager.positionElasticAttract(
			this,
			Hud.getInstance().getGoldIconPos(),
			Hud.getInstance().getContainerEffect(),
			applyResourceGain
		);
		
	}
	
	private function applyResourceGain():Void {}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(this, onClick);
		removeAllListeners();
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}