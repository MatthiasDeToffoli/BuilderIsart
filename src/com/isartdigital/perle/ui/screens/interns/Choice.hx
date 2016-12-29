package com.isartdigital.perle.ui.screens.interns;

import com.isartdigital.perle.game.TextGenerator;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import flump.library.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author grenu
 */
class Choice extends SmartScreen
{
	private var btnDismiss:SmartButton;
	private var presentationChoice:TextSprite;
	private var choiceCard:UISprite;

	private static var MOUSE_DIFF_MAX:Float = 200;
	private static var DIFF_MAX:Float = 80;
	private var mousePos:Point;
	private var imgPos:Point;
	
	public function new(pID:String=null) 
	{
		super("Inter_Event");
		
		presentationChoice = cast(getChildByName("_event_description"), TextSprite);
		btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		choiceCard = cast(getChildByName("_event_FateCard"), UISprite);
		imgPos = new Point(choiceCard.position.x, choiceCard.position.y);
		
		presentationChoice.text = TextGenerator.GetNewSituation()[0];
		
		addListeners();
	}
	
	private function addListeners ():Void {
		btnDismiss.on(MouseEventType.CLICK, closeChoice);	
		choiceCard.interactive = true;
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
	}
	
	/**
	 * Close choice
	 */
	private function closeChoice ():Void {
		UIManager.getInstance().openHud();
		UIManager.getInstance().closeScreens();
	}
	
	/**
	 * Start sliding choice
	 * @param	mEvent
	 */
	private function startFollow(mEvent:EventTarget):Void
	{
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
		if (diff > 0 && Math.abs(diff) < MOUSE_DIFF_MAX) choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
	}
	
	/**
	 * Replace card at start pos
	 */
	private function replaceCard():Void
	{
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		choiceCard.position.set(imgPos.x, imgPos.y);
	}

}