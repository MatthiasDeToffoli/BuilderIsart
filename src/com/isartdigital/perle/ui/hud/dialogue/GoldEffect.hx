package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class GoldEffect extends SmartComponent
{
	
	public static var goldJuicy:Array<UISprite>;
	
	public function new(pAsset:String,pPos:Point, pPosAfterEffect:Point) 
	{
		super(AssetName.BTN_PRODUCTION);
		var graphic:UISprite = new UISprite(pAsset);
		graphic.position = pPos;
		GameStage.getInstance().getIconContainer().addChild(graphic);
		goldJuicy.push(graphic);
		effect(graphic,pPosAfterEffect);
	}
	
	public function effect(pGraphic:UISprite, pPosAfterEffect:Point) {
		TweenManager.positionElasticAttract(
			pGraphic,
			pPosAfterEffect,
			null,
			destroyAfterEffect
		);
	}
	
	private function destroyAfterEffect() {
		if (goldJuicy.length != 0) {
			var lGold:UISprite = goldJuicy[0];
			goldJuicy.splice(0, 1);
			GameStage.getInstance().getIconContainer().removeChild(lGold);
			lGold.destroy();
		}
	}
	
	override public function destroy():Void {
		removeAllListeners();
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
}