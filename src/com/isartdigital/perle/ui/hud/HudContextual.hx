package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

/**
 * todo : finir
 * @author ambroise
 */
class HudContextual extends Container {

	private static var container:Container;
	
	private var myVBuilding:VBuilding;
	
	public static function initClass ():Void {
		container = new Container();
		GameStage.getInstance().getGameContainer().addChild(container);
	}
	
	public function new() {
		super();
	}
	
	public function init (pVBuilding:VBuilding):Void {
		myVBuilding = pVBuilding;
		alignCenter(); // todo : on voudra peut-être mettre sur l'orine du Building
	}
	
	private function alignCenter ():Void {
		x = myVBuilding.graphic.x / 2;
		y = myVBuilding.graphic.y / 2;
	}
	
	override public function destroy():Void {
		myVBuilding.unlinkContextualHud();
		container.removeChild(this);
		super.destroy();
	}
	
	
	
}