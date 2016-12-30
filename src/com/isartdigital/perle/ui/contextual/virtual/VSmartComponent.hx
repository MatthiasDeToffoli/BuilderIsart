package com.isartdigital.perle.ui.contextual.virtual;

import com.isartdigital.perle.game.virtual.Virtual;

/**
 * Is not saved, is not in clippingMap directly, it is contained by a HudContextual that itself
 * is in a VBuilding
 * @author ambroise
 */
class VSmartComponent extends Virtual{
	
	
	private var myVHudContextual:VHudContextual;
	
	public function new() {
		super();
		
	}
	
	public function init (pVHud:VHudContextual):Void {
		myVHudContextual = pVHud;
	}
	
}