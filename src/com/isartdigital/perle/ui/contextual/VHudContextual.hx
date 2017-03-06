package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.contextual.virtual.VButtonProduction;
import com.isartdigital.perle.ui.contextual.virtual.VButtonProductionCollector;
import com.isartdigital.perle.ui.contextual.virtual.VButtonProductionGenerator;
import pixi.core.display.Container;

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
		
		if (myVBuilding.haveRecolter){
			virtualGoldBtn = new VButtonProductionGenerator();
			virtualGoldBtn.init(this);
		} else if (Std.is(myVBuilding, VCollector)  
				&& myVBuilding.currentState != VBuildingState.isUpgrading 
				&& myVBuilding.currentState != VBuildingState.isBuilding) {
			virtualGoldBtn = new VButtonProductionCollector();
			virtualGoldBtn.init(this);
		}
		
		// ajout cartouche d'âme 
		// ajout progressbar
	}
	
	override public function activate ():Void {
		super.activate();
		
		var lHudContextual:HudContextual = new HudContextual();
		graphic = cast(lHudContextual, Container);
		cast(graphic, HasVirtual).linkVirtual(cast(this, Virtual));
		lHudContextual.init();
		
		if(virtualGoldBtn != null) virtualGoldBtn.activate();
	}
	
	override public function desactivate ():Void {
		super.desactivate(); // s'occupe de supprimer de la variable graphic qui contient hudcontextuel
		
		if (virtualGoldBtn != null)
			virtualGoldBtn.desactivate();
	}
	
	override public function destroy():Void {
		if (virtualGoldBtn != null) 
			virtualGoldBtn.desactivate();
		virtualGoldBtn = null;
		myVBuilding.unlinkContextualHud();
		myVBuilding = null;
		
		super.destroy();
	}
	
}