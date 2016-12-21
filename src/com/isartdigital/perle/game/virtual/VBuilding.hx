package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.HudContextual;
import com.isartdigital.perle.ui.hud.ButtonProduction;

/**
 * Used for clipping.
 * Contain everything that's not just graphic.
 * @author ambroise
 */
class VBuilding extends VTile {
	
	private var myGenerator:Generator;
	private var myGeneratorType:GeneratorType = GeneratorType.soft;
	private var prodBtn:ButtonProduction;
	
	private var myContextualHud:HudContextual;
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		RegionManager.addToRegionBuilding(this);
		
		//for the test (let this for kiki)
		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, GeneratorType.soft, 10);
	}
	
	override public function activate ():Void {
		super.activate();
		var myBuilding:Building = Building.createBuilding(tileDesc);
		graphic = cast(myBuilding, FlumpStateGraphic);
		linkVirtual();
		
		myContextualHud = new HudContextual(); // todo : pooling
		myContextualHud.init(this);

		if (prodBtn != null){
			prodBtn.activeWithBuilding(tileDesc, myGeneratorType);
		}
	}
	
	override public function desactivate ():Void {
		super.desactivate();
		myContextualHud.destroy(); // todo : pooling
		
		if (prodBtn != null){
			prodBtn.desactiveWithBuilding();
		}
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
		Hud.getInstance().showBuildingHud(BuildingHudType.RECOLTE, this);
	}
	
	override public function destroy():Void {
		BuildingHud.unlinkVirtualBuilding(this);
		RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].building[tileDesc.mapX].remove(tileDesc.mapY);
		super.destroy();
	}
	
}