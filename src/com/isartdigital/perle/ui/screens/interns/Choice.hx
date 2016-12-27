package com.isartdigital.perle.ui.screens.interns;

import com.isartdigital.perle.game.TextGenerator;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author grenu
 */
class Choice extends SmartScreen
{
	private var btnDismiss:SmartButton;
	private var presentationChoice:TextSprite;
	
	public function new(pID:String=null) 
	{
		super("Inter_Event");
		
		presentationChoice = cast(getChildByName("_event_description"), TextSprite);
		presentationChoice.text = TextGenerator.GetNewSituation()[0];
		
		addListeners();
	}
	
	private function addListeners ():Void {
		btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		btnDismiss.on(MouseEventType.CLICK, closeChoice);
	}
	
	private function  closeChoice ():Void {
		UIManager.getInstance().openHud();
		UIManager.getInstance().closeScreens();
	}

}