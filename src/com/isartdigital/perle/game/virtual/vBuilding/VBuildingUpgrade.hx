package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VMarketingHouse;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * Class for the building'upgrade
 * @author Emeline Berenguier
 */
class VBuildingUpgrade extends VBuilding
{

	private var UpgradeAssetsList:Array<String>;
	public var UpgradeGoldValuesList:Array<String>;
	public var UpgradeMaterialsValuesList:Array<String>;
	
	public var indexLevel:Int;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		indexLevel = 0;
		
	}
	
	public function onClickUpgrade():Void{
		desactivate();
		
		if (tileDesc.level < BuildingName.getMaxLevelByName(tileDesc.buildingName)){
			tileDesc.level++;
		}
		
		var tTime:Float = Date.now().getTime();
		tileDesc.timeDesc = { refTile:tileDesc.id,  end: tTime + 20000, progress: 0, creationDate: tTime };
		currentState = TimeManager.getBuildingStateFromTime(tileDesc);
		TimeManager.addConstructionTimer(tileDesc.timeDesc);
		
		if (currentState == VBuildingState.isBuilding || currentState == VBuildingState.isUpgrading) 
			TimeManager.eConstruct.on(TimeManager.EVENT_CONSTRUCT_END, endOfConstruction);
		
		updateResources();
		
		
		
		activate();
		addExp();
		
		SaveManager.save();	
	}
	
	public function getTileDesc():TileDescription {
		return tileDesc;
	}
	
	override public function addExp():Void 
	{
		ResourcesManager.takeXp(GameConfig.getBuildingByName(tileDesc.buildingName,getLevel()).xPatCreationHell,GeneratorType.badXp);
		ResourcesManager.takeXp(GameConfig.getBuildingByName(tileDesc.buildingName, getLevel()).xPatCreationHeaven, GeneratorType.goodXp);
	}
	
	public function canUpgrade():Bool {
		return tileDesc.level < BuildingName.getMaxLevelByName(tileDesc.buildingName);
	}
	
	public function getLevel():Int{
		return tileDesc.level;
		
	}
}