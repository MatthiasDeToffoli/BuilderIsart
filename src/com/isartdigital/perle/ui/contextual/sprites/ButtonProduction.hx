package com.isartdigital.perle.ui.contextual.sprites;
import com.greensock.easing.Elastic;
import com.greensock.TweenMax;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
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
	private static inline var TWEEN_DURATION:Float = 1.3; // seconds
	private static inline var TWEEN_ELASTIC_PARAM_1:Float = 1;
	private static inline var TWEEN_ELASTIC_PARAM_2:Float = 0.75;
	
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
		tweenToGoldIcon(applyResourceGain);
	}
	
	private function tweenToGoldIcon (pCallBack:Void -> Void):Void {
		var lNewPos:Point = Hud.getInstance().getContainerEffect().toLocal(position, this.parent);
		Hud.getInstance().getContainerEffect().addChild(this);
		position = lNewPos;
		
		TweenMax.to(this, TWEEN_DURATION, { 
			onComplete:pCallBack,
			ease: untyped Elastic.easeOut.config(TWEEN_ELASTIC_PARAM_1, TWEEN_ELASTIC_PARAM_2),
			x:Hud.getInstance().getGoldIconPos().x,
			y:Hud.getInstance().getGoldIconPos().y - height / 2
		} );
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