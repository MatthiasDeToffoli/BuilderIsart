package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VMarketingHouse;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * Class for the building'upgrade
 * @author Emeline Berenguier
 * @author Victor Grenu
 * @author Matthias DeTefolli
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
		tileDesc.timeDesc = { 
			refTile:tileDesc.id,
			// todo : tTime + tTime seem very suspicious !
			end: tTime + tTime + Date.fromString(GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level).constructionTime).getTime(),
			progress: 0,
			creationDate: tTime 
		};
		currentState = TimeManager.getBuildingStateFromTime(tileDesc);
		
		if (currentState == VBuildingState.isBuilding || currentState == VBuildingState.isUpgrading) 
			TimeManager.eConstruct.on(TimeManager.EVENT_CONSTRUCT_END, endOfConstruction);
		
		ServerManagerBuilding.upgradeBuilding(tileDesc);
		
		updateResources();
		
		activate();
		
		BHConstruction.newTimer();
		TimeManager.addConstructionTimer(tileDesc.timeDesc, this);
		
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