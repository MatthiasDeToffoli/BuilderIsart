package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.InternElement;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.sounds.SoundManager;
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
	
	private var internListIndex:Int = 0;
	private static inline var MAX_PLACES:Int = 3;
	private var spawnersPositions:Array<Point> = new Array<Point>();
	
	private var internsInQuestInfo:SmartComponent;
	private var internsInQuestMax:TextSprite;
	private var actualNbInternInQuest:TextSprite;
	
	private var internsHousesInfo:SmartComponent;
	private var internsHousesHeaven:TextSprite;
	private var internsHousesHell:TextSprite;
	
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
		
		SoundManager.getSound("SOUND_OPEN_MENU_INTERN").play();
		
		btnClose = cast(getChildByName(AssetName.BTN_CLOSE), SmartButton);
		btnLeft = cast(getChildByName(AssetName.INTERN_LIST_LEFT), SmartButton);
		btnRight = cast(getChildByName(AssetName.INTERN_LIST_RIGHT), SmartButton);
			
		internsInQuestInfo = cast(getChildByName(AssetName.INTERN_IN_QUEST_VALUE), SmartComponent);
		actualNbInternInQuest = cast(SmartCheck.getChildByName(internsInQuestInfo, AssetName.INTERN_IN_QUEST_VALUE_ACTUAL), TextSprite);
		internsInQuestMax = cast(SmartCheck.getChildByName(internsInQuestInfo, AssetName.INTERN_IN_QUEST_VALUE_MAX), TextSprite);
			
		internsHousesInfo = cast(getChildByName(AssetName.INTERN_HOUSE_NUMBER), SmartComponent);
		internsHousesHeaven = cast(SmartCheck.getChildByName(internsHousesInfo, AssetName.INTERN_HOUSE_NUMBER_HEAVEN), TextSprite);
		internsHousesHell = cast(SmartCheck.getChildByName(internsHousesInfo, AssetName.INTERN_HOUSE_NUMBER_HELL), TextSprite);
			
		setSpawners();
		setValues();		
		spawnQuest();
		
		Interactive.addListenerClick(btnLeft, onLeft);
		Interactive.addListenerClick(btnRight, onRight);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function setValues():Void{
		actualNbInternInQuest.text = Intern.numberInternsInQuest() + "";
		internsInQuestMax.text = UnlockManager.getNumberPlaces() + "";
		
		setValuesNumberHousesHeaven();
		setValuesNumberHousesHell();
	}
	
	/**
	 * Set the correct values of the heaven intern house
	 */
	private function setValuesNumberHousesHeaven():Void{
		if (Intern.numberInternHouses[Alignment.heaven] != null && Intern.internsListAlignment[Alignment.heaven] != null){
			internsHousesHeaven.text = Intern.numberInternHouses[Alignment.heaven] - Intern.internsListAlignment[Alignment.heaven].length + "";
		}
		
		else {
			if (Intern.numberInternHouses[Alignment.heaven] == null) internsHousesHeaven.text = 0 + "";
			if (Intern.internsListAlignment[Alignment.heaven] == null) internsHousesHeaven.text = Intern.numberInternHouses[Alignment.heaven] + "";
		}
	}
	
	/**
	 * Set the correct values of the hell intern house
	 */
	private function setValuesNumberHousesHell():Void{
		if (Intern.numberInternHouses[Alignment.hell] != null && Intern.internsListAlignment[Alignment.hell] != null){
			internsHousesHell.text = Intern.numberInternHouses[Alignment.hell] - Intern.internsListAlignment[Alignment.hell].length + "";
		}
		
		else {
			if (Intern.numberInternHouses[Alignment.hell] == null) internsHousesHell.text = 0 + "";
			if (Intern.internsListAlignment[Alignment.hell] == null) internsHousesHell.text = Intern.numberInternHouses[Alignment.hell] + "";
		}
	}
	
	/**
	 * Get the spawners positions and display them
	 */
	private function setSpawners():Void{
		var lSpawner:UISprite;
		
		for (i in 0...AssetName.internListSpawners.length){
			lSpawner = cast(SmartCheck.getChildByName(this, AssetName.internListSpawners[i]), UISprite);
			spawnersPositions.push(lSpawner.position.clone());
			destroySpawner(lSpawner);
		}
	}
	
	public function spawnQuest():Void {	
		for (i in 0...AssetName.internListSpawners.length){		
			if (i < Intern.internsListArray.length) spawnInternDescription(spawnersPositions[i], Intern.internsListArray[i]);		
		}
	}
	
	/**
	 * create a bloc contains intern description
	 * @param	spawnerName the name of the spawner
	 * @param	 the descritpion of the intern
	 */
	//private function spawnInternDescription(spawnerName:String, pDesc:InternDescription):Void{
	private function spawnInternDescription(spawnerPosition:Point, pDesc:InternDescription):Void{
		var blocDescription:InternElement = (pDesc.quest != null) ? new InternElementInQuest(spawnerPosition, pDesc): new InternElementOutQuest(spawnerPosition, pDesc);
		addChild(blocDescription);
		internDescriptionArray.push(blocDescription);
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
		SoundManager.getSound("SOUND_NEUTRAL").play();
		scrollPrecedent();
	}
	
	private function onRight(){
		SoundManager.getSound("SOUND_NEUTRAL").play();
		scrollNext();
	}
	
	/**
	 * Function to go on the next page of the list
	 */
	public function scrollNext ():Void {
		//trace(internListIndex);
		if ((internListIndex + MAX_PLACES) >= Intern.internsListArray.length)
			internListIndex = 0;
		else
			internListIndex += MAX_PLACES;
		
		if (internListIndex != 0){
			for (i in 0...MAX_PLACES){
				if (Intern.internsListArray[i + internListIndex] != null) spawnInternDescription(spawnersPositions[i], Intern.internsListArray[i + internListIndex]);
				else {
					if(internDescriptionArray[MAX_PLACES - (MAX_PLACES - i)] != null) internDescriptionArray[MAX_PLACES - (MAX_PLACES - i)].parent.removeChild(internDescriptionArray[MAX_PLACES - (MAX_PLACES - i)]);	
				}
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
			
		if (internListIndex != 0){
			for (i in 0...MAX_PLACES){
				if (Intern.internsListArray[i + internListIndex] != null) spawnInternDescription(spawnersPositions[i], Intern.internsListArray[i + internListIndex]);
			}
		}
	}
	
	public function onClose():Void {
		if (Choice.isVisible() || DialogueManager.ftueStepSendIntern || DialogueManager.ftueStepResolveIntern || DialogueManager.ftueStepMakeAllChoice)
			return;
		
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	private function destroyInternElements():Void {
		var lLength:UInt = internDescriptionArray.length;
		var j:UInt;
        for (i in 1...lLength +1) {
			j = lLength - i;
			internDescriptionArray[j].destroy();
			internDescriptionArray.splice(j, 1);
        }
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnLeft, onLeft);
		Interactive.removeListenerClick(btnRight, onRight);
		Interactive.removeListenerClick(btnClose, onClose);
		
		destroyInternElements();
		instance = null;
		
		super.destroy();
	}

}