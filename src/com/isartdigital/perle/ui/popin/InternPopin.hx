package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * popin contained information of a intern (more detailled than ListInternPopin)
 * @author de Toffoli Matthias
 */
class InternPopin extends SmartPopin
{

	private var side:TextSprite;
	private var internName:TextSprite;
	private var btnSend:SmartButton;
	private var btnDismiss:SmartButton;
	private var btnSeeAll:SmartButton;
	private var btnClose:SmartButton;
	
	public function new() 
	{
		super("Interns");
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
		side = cast(getChildByName("_intern_side"), TextSprite);
		internName = cast(getChildByName("_intern_name"), TextSprite);
		side.text = "GDP";
		internName.text = "Alexis";
		
		//btnSend = cast(getChildByName("Bouton_InternSend_Clip"), SmartButton);
		//btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		//btnSeeAll = cast(getChildByName("Bouton_AllInterns_Clip"), SmartButton);
		var interMc:SmartComponent = cast(getChildByName("Bouton_AllInterns_Clip"), SmartComponent);
		btnSeeAll = cast(interMc.getChildByName("Button"), SmartButton);
		
		btnClose = cast(getChildByName("ButtonCancel"), SmartButton);
		
		btnClose.on(MouseEventType.CLICK, onClose);
		btnSeeAll.on(MouseEventType.CLICK, onSeeAll);
	}
	
	private function onClose(){
		Hud.getInstance().show();
		destroy();
	}
	
	private function onSeeAll(){
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
		destroy();
	}
	
	override public function destroy():Void 
	{
		btnSeeAll.off(MouseEventType.CLICK, onSeeAll);
		btnClose.off(MouseEventType.CLICK, onClose);
		parent.removeChild(this);
		super.destroy();
	}
	
}