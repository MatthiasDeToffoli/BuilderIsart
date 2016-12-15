package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.HudContextual;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.display.Container;

/**
 * todo : leur faire une nomenclature >.<, pr le nom de la classe...
 * @author Emeline Berenguier
 */
class Menu_BatimentConstruit extends HudContextual{

	
	private var btnLeft:SmartButton;
	private var btnCenter:SmartButton;
	private var btnRight:SmartButton;
	
	private var VBuildingRef:VBuilding;
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	/**
	 * @param	pVBuilding
	 */
	public function init (pVBuilding:VBuilding):Void {
		modal = null; // todo : quel utilité ?
		x = pVBuilding.graphic.x; // if origin is top middle
		y = pVBuilding.graphic.y;
		
		VBuildingRef = pVBuilding;
		
		addListeners();
	}
	
	private function addListeners ():Void {
		btnLeft = cast(getChildByName("Button_MoveBuilding"), SmartButton);
		btnCenter = cast(getChildByName("Button_EnterBuilding"), SmartButton);
		btnRight = cast(getChildByName("Button_CancelSelection"), SmartButton);
		btnLeft.on(MouseEventType.CLICK, onClickLeft);
		btnCenter.on(MouseEventType.CLICK, onClickCenter);
		btnRight.on(MouseEventType.CLICK, onClickRight);
	}
	
	private function onClickLeft(): Void {
		trace("onClickLeft");
		Building.onClickRemoveBuilding("Villa");
	}
	
	private function onClickCenter(): Void {
		trace("onClickCenter");
	}
	
	private function onClickRight(): Void {
		trace("onClickRight");
		//VBuildingRef.desactivate();
		VBuildingRef.
	}
	
	
	override public function destroy():Void {
		super.destroy();
	}
}