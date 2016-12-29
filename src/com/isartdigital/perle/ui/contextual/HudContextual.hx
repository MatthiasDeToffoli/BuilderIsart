package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VButtonProduction;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * todo : finir
 * @author ambroise
 */
class HudContextual extends Container {

	private static var container:Container;
	
	private var myVBuilding:VBuilding;
	
	public var virtualGoldBtn:VButtonProduction = new VButtonProduction();
	
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
	
	public function init (pVBuilding:VBuilding):Void {
		myVBuilding = pVBuilding;
		
		if (myVBuilding.graphic != null)
			alignCenter();
		
		
		container.addChild(this);
		virtualGoldBtn.init(new Point(0, 0), myVBuilding.tileDesc.id, pVBuilding.myGeneratorType,this);
	}
	
	public function activate ():Void {
		if (position.x == 0 && position.y == 0) // todo : positionnement temporaire au centre du graphique
			alignCenter();
		
		// todo : séparer logique du graphique pr le goldBtn
		virtualGoldBtn.activeWithBuilding();
	}
	
	public function desactivate ():Void {
		virtualGoldBtn.unActivateWithBuild();
	}
	
	private function alignCenter ():Void {
		x = myVBuilding.graphic.x / 2;
		y = myVBuilding.graphic.y / 2;
	}
	
	override public function destroy():Void {
		desactivate();
		myVBuilding.unlinkContextualHud();
		myVBuilding = null;
		container.removeChild(this);
		super.destroy();
	}
	
	
	
}