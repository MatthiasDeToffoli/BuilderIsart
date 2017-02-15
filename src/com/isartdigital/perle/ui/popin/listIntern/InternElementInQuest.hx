package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.popin.InternPopin;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.ResolveButton;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.UIComponent;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * the bloc when intern is in quest
 * @author de Toffoli Matthias
 * @author Emeline Berenguier
 */
class InternElementInQuest extends InternElement
{
	//public static var elementInQuestList:Map<Int, InternElementInQuest> = new Map<Int, InternElementInQuest>();
		
	public static var canPushNewScreen:Bool = false;
	//private var progressIndex:Int = 0;
	private var questTime:SmartComponent;
	private var heroCursor:UISprite;
	private var heroCursorStartPosition:Point;
	private var eventCursor1:UISprite;
	private var eventCursor2:UISprite;
	private var eventCursor3:UISprite;
	private var timeEvent:TextSprite;
	private var questGauge:SmartComponent;
	private var questGaugeLenght:Float;
	private var newEvent:Bool = false;
	public var loop:Timer;
	
	//private var questInProgress:TimeQuestDescription;
	
	public static var eventCursorsArray:Array<UISprite>;
	
	public function new(pPos:Point, pDesc:InternDescription) 
	{		
		super(AssetName.INTERN_INFO_IN_QUEST, pPos);
				
		getComponents();
		
		eventCursorsArray = [eventCursor1, eventCursor2, eventCursor3];
		
		setOnSpawn(pDesc);
		addListeners();
	}
	
	private function getComponents():Void{
		internName = cast(getChildByName(AssetName.INTERN_NAME_IN_QUEST), TextSprite);
		
		questTime = cast(getChildByName(AssetName.TIME_IN_QUEST), SmartComponent);
		heroCursor = cast(SmartCheck.getChildByName(questTime, AssetName.IN_QUEST_HERO_CURSOR), UISprite);
		heroCursorStartPosition = cast(SmartCheck.getChildByName(questTime, AssetName.IN_QUEST_HERO_CURSOR), UISprite).position.clone();
		
		eventCursor1 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent01"), UISprite);
		eventCursor2 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent02"), UISprite);
		eventCursor3 = cast(SmartCheck.getChildByName(questTime, "_listInQuest_nextEvent03"), UISprite);
		
		timeEvent = cast(SmartCheck.getChildByName(questTime, AssetName.IN_QUEST_EVENT_TIME), TextSprite);
		questGauge = cast(getChildByName(AssetName.IN_QUEST_GAUGE), SmartComponent);
	}
	
	private function setOnSpawn(pDesc:InternDescription):Void {
		loop = Timer.delay(progressLoop, 10);
		loop.run = progressLoop;
		
		internName.text = pDesc.name;
		quest = QuestsManager.getQuest(pDesc.id);
		timeEvent.text = getChrono();
		
		questGaugeLenght = cast(questGauge.getChildByName("_listInQuest_progressionBarBG"), UISprite).width;
		
		var prct:Array<Float> = QuestsManager.getCursorPosition(pDesc.id);
		for (i in 0...eventCursorsArray.length) {
			eventCursorsArray[i].position.x = heroCursorStartPosition.x + questGaugeLenght * prct[i];
		}
		
		spawnButton("Bouton_InternSend_Clip");
	}
	
	/**
	 * Spawn the correct button depending of the intern's state (resting, waiting)
	 * @param	spawnerName
	 */
	private function spawnButton(spawnerName:String):Void{
		var spawner:UISprite = cast(getChildByName(spawnerName), UISprite);
		var activeButton:SmartButton = null;
		updateCursorPosition();
		
		if (Intern.isIntravel(Intern.getIntern(quest.refIntern))) Intern.getIntern(quest.refIntern).status = Intern.STATE_RESTING;
		if (Intern.getIntern(quest.refIntern).stress >= Intern.MAX_STRESS) Intern.getIntern(quest.refIntern).status = Intern.STATE_MAX_STRESS; 
		
		if (Intern.getIntern(quest.refIntern).status == Intern.STATE_RESTING) {
			activeButton = new AccelerateButton(spawner.position);
			cast(activeButton, AccelerateButton).spawn(quest);
			Interactive.addListenerClick(activeButton, onBoost);
		}
		
		if (Intern.getIntern(quest.refIntern).status == Intern.STATE_WAITING) {
			activeButton = new ResolveButton(spawner.position);
			Interactive.addListenerClick(activeButton, onResolve);	
		}
		
		if (Intern.getIntern(quest.refIntern).status == Intern.STATE_MAX_STRESS) {
			activeButton = new StressButton(spawner.position);
			Interactive.addListenerClick(activeButton, onStress);
		}
		
		activeButton.position = spawner.position;
		spawner.visible = false;
		addChild(activeButton);
	}
	
	private function addListeners():Void {
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_QUEST_STEP, respawn);
		TimeManager.eTimeQuest.addListener(TimeManager.EVENT_CHOICE_DONE, respawn);
	}
	
	/**
	 * Callback of the resolving of an event
	 */
	private function onResolve():Void {
		if (DialogueManager.ftueStepResolveIntern)
			DialogueManager.endOfaDialogue();
		QuestsManager.choice(quest);
	}
	
	/**
	 * Callback when the intern is stressed
	 */
	private function onStress():Void {
		MaxStressPopin.intern = Intern.getIntern(quest.refIntern);
		UIManager.getInstance().closeCurrentPopin;
		UIManager.getInstance().openPopin(MaxStressPopin.getInstance());
	}

	private function onBoost():Void {
		spawnButton("Bouton_InternSend_Clip");
	}
	
	/**
	 * Gameloop for the progress 
	 */
	private function progressLoop():Void {
		//if (quest != null) quest = QuestsManager.getQuest(quest.refIntern);
		if (heroCursor != null) {
			updateEventCursors();
			if (quest.steps[quest.stepIndex] <= quest.progress) timeEvent.text = "00:00";
			else timeEvent.text = getChrono();
			updateCursorPosition();	
		}
		
		else {
			loop.stop();
		}
		
	}
	
	private function getChrono():String {
		var duration:Float = TimesInfo.calculDateDiff(quest.steps[quest.stepIndex], quest.progress).times;
		return TimesInfo.getClock({ days: 0, times: duration }).hour + ":" + TimesInfo.getClock({ days: 0, times: duration }).minute + ":" + TimesInfo.getClock({ days: 0, times: duration }).seconde + "s";
	}
	
	/**
	 * Change the cursor depending on the current event
	 */
	private function updateEventCursors():Void{	
		for (i in 0...eventCursorsArray.length){
			if (i != quest.stepIndex) eventCursorsArray[i].alpha = 0.5;
			else eventCursorsArray[i].alpha = 1;
		}
	}
	
	/**
	 * Change the position of the cursor
	 */
	private function updateCursorPosition():Void{
		if (quest.progress < quest.end) {
			heroCursor.position.x = heroCursorStartPosition.x + questGaugeLenght * QuestsManager.getPrctAvancment(quest.refIntern);
		}		
		else {
			eventCursor3.alpha = 1;
			heroCursor.position.x = heroCursorStartPosition.x + questGaugeLenght * QuestsManager.getPrctAvancment(quest.refIntern);
			timeEvent.text =  "00:00";
		}
	}
	
	private function respawn(pQuest:TimeQuestDescription):Void{
		if (pQuest.refIntern == quest.refIntern) {
			spawnButton("Bouton_InternSend_Clip");
		}
	}
	
	/**
	 * Precaution function
	 * @param	pQuest
	 */
	private function endQuest(pQuest:TimeQuestDescription):Void{
		if (pQuest.refIntern == quest.refIntern) loop.stop();
	}
	
	
	/**
	 * destroy the spawner
	 * @param spawner to destroy
	 */
	private function destroySpawner(spawner:UISprite):Void{	
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	
	override public function destroy():Void 
	{
		TimeManager.eTimeQuest.removeListener(TimeManager.EVENT_QUEST_STEP, respawn);
		TimeManager.eTimeQuest.removeListener(TimeManager.EVENT_CHOICE_DONE, respawn);
		//Interactive.removeListenerClick(picture, onPicture);
		
		loop.stop();
	}
	
}