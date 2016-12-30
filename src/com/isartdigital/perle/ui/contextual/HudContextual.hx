package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.Virtual.HasVirtual;
import com.isartdigital.perle.ui.contextual.virtual.VButtonProduction;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Only element that is clippable but not Poolable // todo or not ?
 * @author ambroise
 */
class HudContextual extends Container implements HasVirtual{

	private static var container:Container;
	
	private var myVHudContextual:VHudContextual;
	
	public static function initClass ():Void {
		container = new Container();
	}
	
	// not at the same time as initClass
	public static function addContainer ():Void {
		GameStage.getInstance().getGameContainer().addChild(container);
	}
	
	public function new() {
		super();
	}
	
	public function linkVirtual(pVirtual:Virtual):Void {
		myVHudContextual = cast(pVirtual, VHudContextual);
	}
	
	public function init ():Void {
		alignCenter();
		container.addChild(this); // ds start() ?
	}
	
	
	private function alignCenter ():Void {
		x = myVHudContextual.myVBuilding.graphic.x / 2;
		y = myVHudContextual.myVBuilding.graphic.y / 2;
	}
	
	override public function destroy():Void {
		myVHudContextual = null;
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
	
	
	
}