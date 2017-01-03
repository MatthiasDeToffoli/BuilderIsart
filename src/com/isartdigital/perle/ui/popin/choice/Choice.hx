package com.isartdigital.perle.ui.popin.choice;

import com.isartdigital.perle.game.TextGenerator;
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

enum ChoiceType { HEAVEN; EVIL; NONE; }

/**
 * ...
 * @author grenu
 */
class Choice extends SmartPopin
{
	// max distance for the card slide
	private static inline var MOUSE_DIFF_MAX:Float = 200;
	private static inline var DIFF_MAX:Float = 80;
	
	// elements
	private var btnDismiss:SmartButton;
	private var btnAll:SmartButton;
	private var presentationChoice:TextSprite;
	private var heavenChoice:TextSprite;
	private var evilChoice:TextSprite;
	private var choiceCard:UISprite;
	
	private var answer:Array<String>;

	// card slide position properties
	private var mousePos:Point;
	private var imgPos:Point;
	private var choiceType:ChoiceType = ChoiceType.NONE;
	
	public function new(pID:String=null) 
	{
		super("Inter_Event");
		
		presentationChoice = cast(getChildByName("_event_description"), TextSprite);
		heavenChoice = cast(getChildByName("_heavenChoice_text"), TextSprite);
		evilChoice = cast(getChildByName("_hellChoice_text"), TextSprite);
		btnAll = cast(getChildByName("Bouton_AllInterns_Clip"), SmartButton);
		btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		choiceCard = cast(getChildByName("_event_FateCard"), UISprite);
		imgPos = new Point(choiceCard.position.x, choiceCard.position.y);
		
		answer = TextGenerator.GetNewSituation();
		presentationChoice.text = answer[0];
		heavenChoice.text = answer[1];
		evilChoice.text = answer[2];
		
		addListeners();
	}
	
	private function addListeners ():Void {
		btnDismiss.on(MouseEventType.CLICK, closeChoice);
		btnAll.on(MouseEventType.CLICK, openAllInterns);
		choiceCard.interactive = true;
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
	}
	
	/**
	 * Close choice
	 */
	private function closeChoice ():Void {
		Hud.getInstance().show();
		destroy();
	}
	
	private function openAllInterns():Void
	{
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
		destroy();
	}
	
	/**
	 * Start sliding choice
	 * @param	mEvent
	 */
	private function startFollow(mEvent:EventTarget):Void
	{
		choiceType = ChoiceType.NONE;
		mousePos = new Point(mEvent.data.global.x, mEvent.data.global.y);
		choiceCard.on(MouseEventType.MOUSE_MOVE, followMouse);
		choiceCard.on(MouseEventType.MOUSE_UP_OUTSIDE, replaceCard);
		choiceCard.on(MouseEventType.MOUSE_UP, replaceCard);
	}
	
	/**
	 * Follow mouse direction
	 * @param	mEvent
	 */
	private function followMouse(mEvent:EventTarget):Void
	{
		var diff:Float = mEvent.data.global.x - mousePos.x;
		if (diff > 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.EVIL;
			else choiceType = ChoiceType.NONE;
		}
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.HEAVEN;
			else choiceType = ChoiceType.NONE;
		}
	}
	
	/**
	 * Replace card at start pos
	 */
	private function replaceCard():Void
	{
		choiceCard.position.set(imgPos.x, imgPos.y);
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		if (choiceType != ChoiceType.NONE) {
			if (choiceType == ChoiceType.HEAVEN) trace(heavenChoice.text);
			else trace(evilChoice.text);
			closeChoice();
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {		
		parent.removeChild(this);
		
		super.destroy();
	}

}