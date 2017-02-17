package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.BoostManager;
import com.isartdigital.perle.game.managers.BuildingLimitManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.Virtual.HasVirtual;
import com.isartdigital.perle.game.virtual.vBuilding.VAltar;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VMarketingHouse;
import com.isartdigital.perle.ui.contextual.VHudContextual;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import pixi.core.display.Container;
import pixi.core.math.Point;

enum VBuildingState { isBuilt; isBuilding; isUpgrading; isMoving; }

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
	
	public var myGenerator:Generator;
	private var timeDesc:TimeDescription;
	public var myGeneratorType:GeneratorType = GeneratorType.soft;
	private var myMaxContains:Float = 10;
	
	/**
	 * said if we can recolt resources with a button in this building
	 */
	public var haveRecolter:Bool;
	
	private var myVContextualHud:VHudContextual;
	
	private var myTime:Float = TimesInfo.MIN;
	
	public var currentState:VBuildingState; // todo : temporaire
	
	public var alignementBuilding:Alignment;
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		
		RegionManager.addToRegionBuilding(this);	
		
		timeDesc = pDescription.timeDesc;
		currentState = TimeManager.getBuildingStateFromTime(pDescription);	
		if (currentState == VBuildingState.isBuilding || currentState == VBuildingState.isUpgrading) {
			TimeManager.addConstructionTimer(pDescription.timeDesc, this);
			TimeManager.eConstruct.on(TimeManager.EVENT_CONSTRUCT_END, endOfConstruction);
		}
		else {
			setHaveRecolter();
			addGenerator();
			ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, updateGeneratorInfo);
		}
		
		addHudContextual();
		incrementNumberBuilding();
		
		checkIfIsInAltarZone();
		BoostManager.boostAltarEvent.on(BoostManager.ALTAR_EVENT_NAME, onAltarCheck);
	}
	
	
	private function updateResources():Void {
		var typeBuilding:TableTypeBuilding = GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level);
			
		if (typeBuilding.productionPerHour != null && !Std.is(this, VMarketingHouse)) {
			
			myTime = calculTimeProd(typeBuilding);
			myGenerator = ResourcesManager.UpdateResourcesGenerator(myGenerator, getMaxContains(typeBuilding), myTime);	
		}
	}
	
	
	/**
	 * add this reference to an altar
	 */
	private function checkIfIsInAltarZone():Void {
		BoostManager.buildingIsInAltarZone(true, tileDesc.id, alignementBuilding,{x:tileDesc.regionX, y:tileDesc.regionY}, {x:tileDesc.mapX, y:tileDesc.mapY});
	}
	
	/**
	 * remove the reference to an altar if is referenced
	 */
	private function checkIfIsOutAnAltarZone():Void {
		BoostManager.buildingIsInAltarZone(false, tileDesc.id, alignementBuilding,{x:tileDesc.regionX, y:tileDesc.regionY});
	}
	
	/**
	 * set true or false in the flag which say if the building have recolter (true by default)
	 */
	private function setHaveRecolter():Void{
		haveRecolter = true;
	}
	
	private function incrementNumberBuilding():Void {
		BuildingLimitManager.incrementMapNumbersBuildingPerRegion(tileDesc.regionX, tileDesc.regionY, tileDesc.buildingName);
	}
	
	private function decrementNumberBuilding():Void {
		BuildingLimitManager.decrementMapNumbersBuildingPerRegion(tileDesc.regionX, tileDesc.regionY, tileDesc.buildingName);
	}
	
	override public function activate():Void {
		super.activate();
		graphic = cast(Building.createBuilding(tileDesc,currentState), Container);
		cast(graphic, HasVirtual).linkVirtual(cast(this, Virtual)); // alambiqué ?
		if (haveRecolter || Std.is(this, VCollector) && currentState != VBuildingState.isUpgrading && currentState != VBuildingState.isBuilding) 
			myVContextualHud.activate();
	}
	
	/**
	 * say if this building is in the altar zone
	 * @param	pData data contain the region and the case to check
	 */
	private function onAltarCheck(pData:BoostInfo):Void {
		if (pData.regionPos.x != tileDesc.regionX || pData.regionPos.y != tileDesc.regionY) return;
		
		var i:Int, j:Int;
		var mapSize:SizeOnMap = Building.getSizeOnMap(tileDesc.buildingName);
		
		for (i in tileDesc.mapX...(tileDesc.mapX + mapSize.width)){
			for (j in tileDesc.mapX...(tileDesc.mapY + mapSize.height)){
			 if (i == pData.casePos.x && j == pData.casePos.y) checkIfIsInAltarZone();
			}	
		}
	}
	
	public function reShow():Void {
		desactivate();
		activate();
	}
	
	public function getVirtualContextualHud():VHudContextual{
		return myVContextualHud;
	}
	
	public function updateGeneratorInfo(?data:Dynamic){
		if (myGenerator != null && data.id == tileDesc.id)
			myGenerator.desc = ResourcesManager.getGenerator(tileDesc.id, myGeneratorType);
	}
	
	override public function desactivate ():Void {
		super.desactivate();
		
		if (myVContextualHud != null)
			myVContextualHud.desactivate();
			
		if (timeDesc != null) {
			BHConstruction.hideTimer(timeDesc);
		}
	}
	
	public function unlinkContextualHud ():Void {
		// todo : je peux pas juste faire destroy() puis myContextualHud = null dans cette class ?
		myVContextualHud = null;
	}
	
	public function getGenerator():Generator {
		return myGenerator;
	}
	
	/**
	 * Called when user click on the graphic
	 */
	public function onClick (pPos:Point):Void {
		Hud.getInstance().onClickBuilding(currentState, this,pPos);
	}
	
	public function onClickMove ():Void {	
		Phantom.onClickMove(
			BuildingHud.virtualBuilding.tileDesc.buildingName,
			BuildingHud.virtualBuilding.tileDesc.level,
			this
		);
		
		//Hud.getInstance().buildingPosition = BuildingHud.virtualBuilding.graphic.position;
		desactivate();
		ignore = true;
		setState(VBuildingState.isMoving);
	}
	
	public function getAsset():String {
		var lVBuilding:VBuilding;
		
		if (BuildingHud.virtualBuilding != null) lVBuilding = BuildingHud.virtualBuilding;
		else lVBuilding = InfoBuilding.getVirtualBuilding();
		
		return cast(lVBuilding.graphic, Building).getAssetName();
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
		checkIfIsOutAnAltarZone();
		decrementNumberBuilding();
		updateWorldMapPosition(pRegionMap);
		activate();
		// todo : change bellow if possible to move building when constructing
		// gérer quand building en construction
		setState(VBuildingState.isBuilt); 
	}
	
	private function setState (pState:VBuildingState):Void {
		if (currentState == VBuildingState.isBuilt) {
			
			if (pState == VBuildingState.isBuilding)
				trace("upgrading building ! (todo)"); // todo
			
			if (pState == VBuildingState.isMoving)
				setModeMove();
				
		} else if (currentState == VBuildingState.isBuilding || currentState == VBuildingState.isUpgrading) {
			
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
	
	
	public function addExp():Void {
		//todo pas une valeur en dur : 100
		/*if (alignementBuilding == null || alignementBuilding == Alignment.neutral) {
			ResourcesManager.takeXp(, GeneratorType.badXp);
			ResourcesManager.takeXp(100, GeneratorType.goodXp);
		}
		else if (alignementBuilding == Alignment.hell)
			ResourcesManager.takeXp(100, GeneratorType.badXp);
		else if (alignementBuilding == Alignment.heaven)
			ResourcesManager.takeXp(200, GeneratorType.goodXp);*/
			
		ResourcesManager.takeXp(GameConfig.getBuildingByName(tileDesc.buildingName).xPatCreationHell,GeneratorType.badXp);
		ResourcesManager.takeXp(GameConfig.getBuildingByName(tileDesc.buildingName).xPatCreationHeaven, GeneratorType.goodXp);
			
	}
	
	public function getGoldValue():String {
		return GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level).productionPerHour + "";
	}
	
	public function getRessourceValue():String {
		return GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level).productionResource + "";
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
		checkIfIsInAltarZone();
	}
	
	private function addGenerator():Void {

		var typeBuilding:TableTypeBuilding = GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level);
		if ((typeBuilding.productionPerHour == null && !Std.is(this,VAltar)) || Std.is(this, VMarketingHouse)) return;

		myTime = calculTimeProd(typeBuilding);
		myGeneratorType = ServerManager.stringToEnum(typeBuilding.productionResource.toString());
		myMaxContains = getMaxContains(typeBuilding);

		myGenerator = ResourcesManager.addResourcesGenerator(tileDesc.id, myGeneratorType, myMaxContains,myTime,Std.is(this,VTribunal) ? Alignment.neutral:null, Std.is(this,VTribunal) ? true:false);
	}
	
	private function getMaxContains(?pTypeBuilding:TableTypeBuilding):Int {
		return pTypeBuilding.maxGoldContained;
	}
	
	private function calculTimeProd(?pTypeBuilding:TableTypeBuilding):Float {
		return TimesInfo.HOU / pTypeBuilding.productionPerHour;
	}
	
	private function addHudContextual ():Void {
		myVContextualHud = new VHudContextual();
		myVContextualHud.init(this);
	}
	
	private function endOfConstruction(pElement:TimeDescription):Void {
		if (pElement.refTile != tileDesc.id) return;
		timeDesc = null;
		
		if (active) cast(graphic, Building).setStateEndConstruction();
		
		setState(VBuildingState.isBuilt);
		
		setHaveRecolter();
		addGenerator();
		ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, updateGeneratorInfo);
		myVContextualHud.activate();
		addExp();
		
		Hud.getInstance().changeBuildingHud(BuildingHudType.HARVEST, this);
		TimeManager.eConstruct.off(TimeManager.EVENT_CONSTRUCT_END, endOfConstruction);
		SaveManager.save();
	}
	
	override public function destroy():Void {
		checkIfIsOutAnAltarZone();
		decrementNumberBuilding();
		BoostManager.boostAltarEvent.off(BoostManager.ALTAR_EVENT_NAME, onAltarCheck);
		if (currentState == VBuildingState.isMoving) {
			throw ("Sure about destroying a moving VBuilding ?? not an error ? ask Ambroise");
			// if yes => todo : Phantom.linkedVBuilding = null;
		}
		
		myVContextualHud.destroy();
		myVContextualHud = null;
		
		var lVBuilding:VBuilding;
		
		if (this != null) lVBuilding = this;
		else lVBuilding = InfoBuilding.getVirtualBuilding();
		
		BuildingHud.unlinkVirtualBuilding(lVBuilding);
		RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].building[tileDesc.mapX].remove(tileDesc.mapY);
		TimeManager.destroyTimeElement(tileDesc.id);	
		
		if (myGenerator != null){
			ResourcesManager.removeGenerator(myGenerator);
			myGenerator = null;
			ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, updateGeneratorInfo);
		}
		
		super.destroy();
	}
	
}