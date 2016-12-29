package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.contextual.HudContextual;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;

enum VBuildingState { isBuilt; isBuilding; isMoving; }

/*extern class VBuildingClickEvent extends EventEmitter { // todo : mail Mathieu
	override public function addListener(event:String, fn:VBuildingState -> VBuilding ->Void, ?context:Dynamic):Void {
		super.addListener(event, fn, context);
	}
}*/

/**
 * Used for clipping.
 * Contain everything that's not just graphic.
 * @author ambroise
 */
class VBuilding extends VTile {
	
	private var myGenerator:Generator;
	public var myGeneratorType:GeneratorType = GeneratorType.soft;
	
	private var myContextualHud:HudContextual;
	
	public var currentState(default, null):VBuildingState = VBuildingState.isBuilt; // todo : temporaire
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		RegionManager.addToRegionBuilding(this);
		
		addGenerator();
		addHudContextual();
		
	}
	
	override public function activate ():Void {
		super.activate();
		
		var myBuilding:Building = Building.createBuilding(tileDesc);
		graphic = cast(myBuilding, FlumpStateGraphic);
		cast(graphic, Building).linkedVirtualCell = this;
		
		myContextualHud.activate();
	}
	
	override public function desactivate ():Void {
		super.desactivate();
		
		myContextualHud.desactivate();
	}
	
	public function unlinkContextualHud ():Void {
		// todo : je peux pas juste faire destroy() puis myContextualHud = null dans cette class ?
		myContextualHud = null;
	}
	
	public function getGenerator():Generator {
		return myGenerator;
	}
	
	/**
	 * Called when user click on the graphic
	 */
	public function onClick ():Void {
		Hud.getInstance().onClickBuilding(currentState, this);
	}
	
	public function onClickMove ():Void {
		Phantom.onClickMove(
			cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName(),
			this
		);
		desactivate();
		ignore = true;
		setState(VBuildingState.isMoving);
	}
	
	public function onClickCancel ():Void {
		Phantom.onClickCancelMove();
		ignore = false;
		activate();
		setState(VBuildingState.isBuilt);
	}
	
	public function onClickConfirm ():Void {
		Phantom.onClickConfirmMove();
	}
	
	public function move (pRegionMap:RegionMap):Void {
		updateWorldMapPosition(pRegionMap);
		activate();
		// change bellow if possible to move building when constructing
		setState(VBuildingState.isBuilt); 
	}
	
	private function setState (pState:VBuildingState):Void {
		if (currentState == VBuildingState.isBuilt) {
			
			if (pState == VBuildingState.isBuilding)
				trace("upgrading building ! (todo)"); // todo
			
			if (pState == VBuildingState.isMoving)
				setModeMove();
				
		} else if (currentState == VBuildingState.isBuilding) {
			
			if (pState == VBuildingState.isMoving)
				throw("can't move while building !");
				
			if (pState == VBuildingState.isBuilt)
				setModeBuilt();
			
		} else if (currentState == VBuildingState.isMoving) {
			
			if (pState == VBuildingState.isBuilt)
				setModeBuilt();
			
			if (pState == VBuildingState.isBuilding)
				throw("can't construct building while moving !");
			
		} else {
			throw('setState failed');
		}
	}
	
	/**
	 * Will remove graphic until currentState != isMoving
	 */
	private function setModeMove ():Void {
		currentState = VBuildingState.isMoving;
	}
	
	private function setModeBuilt ():Void {
		currentState = VBuildingState.isBuilt;
	}
	
	private function updateWorldMapPosition (pRegionMap:RegionMap):Void {
		RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].building[tileDesc.mapX].remove(tileDesc.mapY);
		
		tileDesc.regionX = pRegionMap.region.x;
		tileDesc.regionY = pRegionMap.region.y;
		tileDesc.mapX = pRegionMap.map.x;
		tileDesc.mapY = pRegionMap.map.y;
		
		RegionManager.addToRegionBuilding(this); // todo : FACTORISER addToRegionBuilding
	}
	
	private function addGenerator ():Void {
		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, myGeneratorType, 10);
	}
	
	private function addHudContextual ():Void {
		myContextualHud = new HudContextual();
		myContextualHud.init(this);
	}
	
	override public function destroy():Void {
		if (currentState == VBuildingState.isMoving) {
			throw ("Sure about destroying a moving VBuilding ?? not an error ? ask Ambroise");
			// if yes => todo : Phantom.linkedVBuilding = null;
		}
		
		desactivate();
		myContextualHud.destroy();
		myContextualHud = null;
		BuildingHud.unlinkVirtualBuilding(this);
		RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].building[tileDesc.mapX].remove(tileDesc.mapY);
		TimeManager.destroyTimeElement(tileDesc.id);
		ResourcesManager.removeGenerator(myGenerator); // todo : @Matthias
		
		super.destroy();
	}
	
}