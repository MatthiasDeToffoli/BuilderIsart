package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.InternElement;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;

	
/**
 * contain informations of all interns
 * @author de Toffoli Matthias
 * @author Emeline Berenguier
 */
class ListInternPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe InternPopin
	 */
	private static var instance: ListInternPopin;
	
	private var btnClose:SmartButton;
	private var btnLeft:SmartButton;
	private var btnRight:SmartButton;
	public var internDescriptionArray:Array<InternElement> = new Array<InternElement>();
	private var unlockLevels:Array<Int> = [1, 11, 14, 20];
	private var placesUnlock:Map<Int, Int> = [1 => 2, 11 => 2, 14 => 3, 20 => 4];
	
	private var internListIndex:Int = 0;
	private static inline var MAX_PLACES:Int = 2;
	private var internsPositions:Array<Point>;
	
	private var internsInQuestInfo:SmartComponent;
	private var actualNbInternInQuest:TextSprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ListInternPopin {
		if (instance == null) instance = new ListInternPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.INTERN_LIST);
		
			btnClose = cast(getChildByName(AssetName.BTN_CLOSE), SmartButton);
			btnLeft = cast(getChildByName(AssetName.INTERN_LIST_LEFT), SmartButton);
			btnRight = cast(getChildByName(AssetName.INTERN_LIST_RIGHT), SmartButton);
			
			//getSpawnersPosition();
			//Create empty places for quests in function of the player's level
			for (i in 0...AssetName.internListSpawners.length){
				
				if (i < Intern.internsListArray.length && i < getNumberPlaces()){
				//if (i < Intern.internsListArray.length){
					spawnInternDescription(AssetName.internListSpawners[i], Intern.internsListArray[i]);
				}
				
				else destroySpawner(cast(getChildByName(AssetName.internListSpawners[i]), UISprite));
			}
		
		Interactive.addListenerClick(btnLeft, onLeft);
		Interactive.addListenerClick(btnRight, onRight);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	/**
	 * Get the correct number of empty places availables
	 * @return
	 */
	private function getNumberPlaces():Int{
		var lNumberPlaces:Int = 0;
		
		for (i in 0...unlockLevels.length){
			if (unlockLevels[i] <= ResourcesManager.getLevel() && ResourcesManager.getLevel() < unlockLevels[i + 1]){
				lNumberPlaces = placesUnlock[unlockLevels[i]];
				return lNumberPlaces;
			}
			if (unlockLevels[unlockLevels.length - 1] <= ResourcesManager.getLevel()){
				lNumberPlaces = placesUnlock[unlockLevels[unlockLevels.length - 1]];
				return lNumberPlaces; 
			}
		}
		return lNumberPlaces;
	}
	
	/**
	 * create a bloc contains intern description
	 * @param	spawnerName the name of the spawner
	 * @param	 the descritpion of the intern
	 */
	private function spawnInternDescription(spawnerName:String, pDesc:InternDescription):Void{
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, spawnerName), UISprite);
		var blocDescription:InternElement = (pDesc.quest != null) ? new InternElementInQuest(spawner.position, pDesc): new InternElementOutQuest(spawner.position, pDesc);
		addChild(blocDescription);
		internDescriptionArray.push(blocDescription);
		destroySpawner(spawner);
	}
	
	/**
	 * destroy the spawner
	 * @param	spawner spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	private function onLeft(){
		//scrollPrecedent();
	}
	
	private function onRight(){
		//scrollNext();
	}
	
	/**
	 * Function to go on the next page of the list
	 */
	public function scrollNext ():Void {
		trace(internListIndex);
		if ((internListIndex + MAX_PLACES) >= Intern.internsListArray.length)
			internListIndex = 0;
		else
			internListIndex += MAX_PLACES;
		
		for (i in 0...AssetName.internListSpawners.length){
			if (i < Intern.internsListArray.length){
				spawnInternDescription(AssetName.internListSpawners[i], Intern.internsListArray[i + internListIndex]);
			}
			
		}
	}
	
	/**
	 * Function to go on the previous page of the list
	 */
	public function scrollPrecedent ():Void {
		if ((internListIndex - MAX_PLACES) < 0)
			internListIndex = Intern.internsListArray.length - (Intern.internsListArray.length % MAX_PLACES);
		else
			internListIndex -= MAX_PLACES;
		
		for (i in 0...AssetName.internListSpawners.length){
			if (i < Intern.internsListArray.length){
			spawnInternDescription(AssetName.internListSpawners[i], Intern.internsListArray[internListIndex - i]);
			}
			
		}
	}
	
	public function onClose():Void {
		if (Choice.isVisible() || DialogueManager.ftueStepSendIntern || DialogueManager.ftueStepResolveIntern || DialogueManager.ftueStepMakeAllChoice)
			return;
		
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnLeft, onLeft);
		Interactive.removeListenerClick(btnRight, onRight);
		Interactive.removeListenerClick(btnClose, onClose);
		
		var myInternDesc:InternDescription;
		for (myInternDesc in internDescriptionArray){
			myInternDesc.destroy();
			internDescriptionArray.shift();
		}
		instance = null;
		
		super.destroy();
	}

}