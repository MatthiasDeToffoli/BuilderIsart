package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;

/**
 * Sert à la fois pour l'héritage et comme manager,
 * j'ai pas envie de touché le UIManager.. si Mathieu le modifie encore...
 * @author ambroise
 */
class HudContextual extends SmartComponent {

	private static var currentBuildingHudC:Menu_BatimentConstruit;

	private static var container:Container;
	
	public static function initClass ():Void {
		container = new Container();
		GameStage.getInstance().getGameContainer().addChild(container);
	}
	
	public static function createOnBuilding (pVBuilding:VBuilding):Void {
		// créer l'hud par dessus le building
		// pas besoin d'informer Vtile
		if (currentBuildingHudC != null)
			currentBuildingHudC.destroy();
		currentBuildingHudC = new Menu_BatimentConstruit();
		currentBuildingHudC.init(pVBuilding);
		container.addChild(currentBuildingHudC);
	}
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	override public function destroy():Void {
		// TODO : va détruire l'hud contextuel d'un batiment
		// à l'appell de n'importe quel destroy des classes hériant,
		// déplacer dans class correspondante ?
		currentBuildingHudC = null; 
		container.removeChild(this);
		super.destroy();
	}
	
	
	
}