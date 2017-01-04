package com.isartdigital.perle.ui.popin.choice;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TextGenerator;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import flump.library.Point;
import pixi.interaction.EventTarget;

enum ChoiceType { HEAVEN; HELL; NONE; }
enum ChoiceGeneratedText {DESC; HELL; HEAVEN; }

/**
 * Choice popin
 * @author grenu
 */
class Choice extends SmartPopin
{
	private static var instance:Choice;
	
	// max distance for the card slide
	private static inline var MOUSE_DIFF_MAX:Float = 200;
	private static inline var DIFF_MAX:Float = 80;
	
	// elements
	private var btnDismiss:SmartButton;
	private var btnAll:SmartButton;
	private var presentationChoice:TextSprite;
	private var heavenChoice:TextSprite;
	private var evilChoice:TextSprite;
	private var internName:TextSprite;
	private var internSide:TextSprite;
	private var choiceCard:UISprite;
	
	private var textDescAnswer:Map<ChoiceGeneratedText, String>;
	
	private var internTest:InternDescription = {id:5, name:"Stagiaire ange", isInQuest:true };

	// card slide position properties
	private var mousePos:Point;
	private var imgPos:Point;
	private var choiceType:ChoiceType;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Choice{
		if (instance == null) instance = new Choice();
		return instance;
	}
	
	public function new(pID:String=null) 
	{
		super(AssetName.INTERN_EVENT);
		
		getComponents();
		
		addInternInfo();
		createChoiceText();
		
		choiceType = ChoiceType.NONE;
		imgPos = new Point(choiceCard.position.x, choiceCard.position.y);
		
		addListeners();
	}
	
	/**
	 * show intern name, side...
	 */
	private function addInternInfo():Void
	{
		internName.text = internTest.name;
		internSide.text = "Ange";
	}
	
	/**
	 * get all intern event popin elements
	 */
	private function getComponents():Void
	{
		presentationChoice = cast(getChildByName(AssetName.INTERN_EVENT_DESC), TextSprite);
		heavenChoice = cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_CHOICE), TextSprite);
		evilChoice = cast(getChildByName(AssetName.INTERN_EVENT_HELL_CHOICE), TextSprite);
		internName = cast(getChildByName(AssetName.INTERN_EVENT_NAME), TextSprite);
		internSide = cast(getChildByName(AssetName.INTERN_EVENT_SIDE), TextSprite);
		btnAll = cast(getChildByName(AssetName.INTERN_EVENT_SEE_ALL), SmartButton);
		btnDismiss = cast(getChildByName(AssetName.INTERN_EVENT_DISMISS), SmartButton);
		choiceCard = cast(getChildByName(AssetName.INTERN_EVENT_CARD), UISprite);
	}
	
	/**
	 * get new generated text
	 */
	public function createChoiceText():Void
	{
		var txtChoice:Array<String> = TextGenerator.GetNewSituation();
		textDescAnswer = [ ChoiceGeneratedText.DESC => txtChoice[0], ChoiceGeneratedText.HELL => txtChoice[2], ChoiceGeneratedText.HEAVEN => txtChoice[1] ];
		presentationChoice.text = textDescAnswer[ChoiceGeneratedText.DESC];
		heavenChoice.text = textDescAnswer[ChoiceGeneratedText.HEAVEN];
		evilChoice.text = textDescAnswer[ChoiceGeneratedText.HELL];
	}
	
	private function addListeners ():Void {
		btnDismiss.on(MouseEventType.CLICK, onDismiss);
		btnAll.on(MouseEventType.CLICK, onSeeAll);
		choiceCard.interactive = true;
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
	}
	
	/**
	 * Close choice
	 */
	private function onDismiss ():Void {
		onClose();
	}
	
	private function onSeeAll():Void
	{
		hide();
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	/**
	 * Start sliding choice
	 * @param	mEvent
	 */
	private function startFollow(mEvent:EventTarget):Void
	{
		// update choiceType
		choiceType = ChoiceType.NONE;
		// click mouse pos
		mousePos = new Point(mEvent.data.global.x, mEvent.data.global.y);
		// add listener needed to follow mouse
		choiceCard.on(MouseEventType.MOUSE_MOVE, followMouse);
		choiceCard.on(MouseEventType.MOUSE_UP_OUTSIDE, replaceCard);
		choiceCard.on(MouseEventType.MOUSE_UP, replaceCard);
	}
	
	/**
	 * Make the fateCard follow mouse direction and get the selected answer
	 * @param	mEvent
	 */
	private function followMouse(mEvent:EventTarget):Void
	{
		// get difference with previous mouse pos
		var diff:Float = mEvent.data.global.x - mousePos.x;
		
		// move fateCard && get choiceType
		if (diff > 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.HELL;
			else choiceType = ChoiceType.NONE;
		}
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.HEAVEN;
			else choiceType = ChoiceType.NONE;
		}
	}
	
	/**
	 * Replace fatecard at start pos && do answer choice if actual choice not NONE
	 */
	private function replaceCard():Void
	{	
		choiceCard.position.set(imgPos.x, imgPos.y);
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		
		if (choiceType != ChoiceType.NONE) {
			if (choiceType == ChoiceType.HEAVEN) chooseHeavenCHoice();
			else chooseHellChoice();
			onClose();
		}
	}
	
	/**
	 * validate hell choice
	 */
	private function chooseHellChoice():Void
	{
		trace(textDescAnswer[ChoiceGeneratedText.HELL]);
	}
	
	/**
	 * validate heaven choice
	 */
	private function chooseHeavenCHoice():Void
	{
		trace(textDescAnswer[ChoiceGeneratedText.HEAVEN]);
	}
	
	/**
	 * onClose
	 */
	private function onClose():Void
	{
		Hud.getInstance().show();
		destroy();
	}
	
	/**
	 * hide the popin
	 */
	public function hide():Void{
		GameStage.getInstance().getHudContainer().removeChild(this);
	}
	
	/**
	 * hide the hud
	 */
	public function show():Void{
		GameStage.getInstance().getHudContainer().addChild(this);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		parent.removeChild(this);
		instance = null;
		super.destroy();
	}

}