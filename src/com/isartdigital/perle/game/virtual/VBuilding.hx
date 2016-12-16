package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;

/**
 * Used for clipping.
 * Contain everything that's not just graphic.
 * @author ambroise
 */
class VBuilding extends VTile {

	private var myTimeElement:TimeElementResource;
	
	//if we do a legacy of VBuilding, we have to give the right type
	private var myGenerator:Dynamic;
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		RegionManager.addToRegionBuilding(this);
		
		//for the test (let this for kiki)
		myGenerator = ResourcesManager.addSoftGenerator(tileDesc.id, 10);
		
		checkHasTimeElement();
		addTimeElement();
	}
	
	override public function activate():Void {
		super.activate();
		var myBuilding:Building = Building.createBuilding(tileDesc);
		graphic = cast(myBuilding, FlumpStateGraphic);
		linkVirtual();
		
		myBuilding.goldBtn.setMyGenerator();
	}
	
	// todo : temporaire, tous ne nécéssite pas un timeElement
	private function addTimeElement ():Void {
		// todo : temporaire, ya le tick correspondant au gain de currencie
		// c'est lié au resourceManager donc n'a pas forcément sa place ici
		// on pourrait mettre le TimeElement dans resourceManager éventuellement.
		// à réfléchir
		var lTestResourceTimeTick:Float = 2000;
		
		if (myTimeElement == null) 
			myTimeElement = TimeManager.createResource(tileDesc.id, lTestResourceTimeTick);
		
		listenToTimeElement();
	}
	
	public function getGenerator():Dynamic {
		return myGenerator;
	}
	
	private function checkHasTimeElement ():Void {
		myTimeElement = TimeManager.getTimeElement(tileDesc.id);
		listenToTimeElement();
	}
	
	private function listenToTimeElement ():Void {
		if (myTimeElement != null)
			myTimeElement.eEndReached.on(TimeManager.EVENT_RESOURCE_END_REACHED, onEndReached);
	}
	
	private function onEndReached (pEvent:Dynamic):Void {
		trace("hello endReached in Vbuilding !");
		trace("numberReached : " +  pEvent);
		// pas besoin à mon avis de passer par Vbuilding pour impacter la currencie
		// met direct un listener dans ton resourcemanager je pense.
		// après faut qu'on ce concerte pr que tout fonctionne bien
	}
}