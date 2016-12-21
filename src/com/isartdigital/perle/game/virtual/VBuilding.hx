package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.contextual.HudContextual;

enum VBuildingState { isBuilt; isBuilding; isMoving; }

/**
 * Used for clipping.
 * Contain everything that's not just graphic.
 * @author ambroise
 */
class VBuilding extends VTile {
	
	private var myGenerator:Generator;
	private var myGeneratorType:GeneratorType = GeneratorType.soft;
	
	private var myContextualHud:HudContextual;
	
	private var currentState:VBuildingState = VBuildingState.isBuilt; // todo : temporaire
	
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
		linkVirtual();

		myContextualHud.activate();
		
		// todo : séparer logique du graphique pr le goldBtn
		/*if (myContextualHud.goldBtn != null){
			myContextualHud.goldBtn.activeWithBuilding(tileDesc, myGeneratorType);
		}*/
		
		myContextualHud.goldBtn.setMyGenerator(myGeneratorType);
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
	public function onClick():Void {
		// todo : avoir des states : enum (?), isBuilding, isBuilt, isMoving
		// et du coup un différent BuildingHudType à chaque fois
		
		if (currentState == VBuildingState.isBuilt)
			Hud.getInstance().showBuildingHud(BuildingHudType.HARVEST, this);
		else if (currentState == VBuildingState.isBuilding)
			Hud.getInstance().showBuildingHud(BuildingHudType.CONSTRUCTION, this);
		else if (currentState == VBuildingState.isMoving)
			Hud.getInstance().showBuildingHud(BuildingHudType.MOVING, this);
	}
	
	private function addGenerator ():Void {
		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, GeneratorType.soft, 10);
	}
	
	private function addHudContextual ():Void {
		myContextualHud = new HudContextual();
		myContextualHud.init(this);
	}
	
	override public function destroy():Void {
		myContextualHud.destroy();
		myContextualHud = null;
		BuildingHud.unlinkVirtualBuilding(this);
		RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].building[tileDesc.mapX].remove(tileDesc.mapY);
		super.destroy();
	}
	
}