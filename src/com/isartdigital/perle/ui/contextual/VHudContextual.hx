package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.ui.contextual.virtual.VButtonProduction;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Is not saved, is not in clipping List directly, is contained by VBuilding
 * @author ambroise
 */
class VHudContextual extends Virtual{
	
	public var myVBuilding:VBuilding;
	
	private var virtualGoldBtn:VButtonProduction;
	// ajout cartouche d'âme 
	// ajout progressbar
	
	public function new() {
		super();
		
	} 
	
	public function init (pVBuilding:VBuilding):Void {
		myVBuilding = pVBuilding;
		virtualGoldBtn = new VButtonProduction();
		virtualGoldBtn.init(this);
		
		// ajout cartouche d'âme 
		// ajout progressbar
	}
	
	override public function activate ():Void {
		super.activate();
		
		var lHudContextual:HudContextual = new HudContextual();
		graphic = cast(lHudContextual, Container);
		cast(graphic, HasVirtual).linkVirtual(cast(this, Virtual));
		lHudContextual.init();
		
		
		
		virtualGoldBtn.activate();
	}
	
	override public function desactivate ():Void {
		super.desactivate(); // s'occupe de supprimer de la variable graphic qui contient hudcontextuel
		
		virtualGoldBtn.desactivate();
	}
	
	override public function destroy():Void {
		myVBuilding.unlinkContextualHud();
		myVBuilding = null;
		virtualGoldBtn.destroy();
		super.destroy();
	}
	
}