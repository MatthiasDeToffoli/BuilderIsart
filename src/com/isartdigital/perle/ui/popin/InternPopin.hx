package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
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
		super(AssetName.INTERN_POPIN);
			
		side = cast(getChildByName(AssetName.INTERN_POPIN_SIDE), TextSprite);
		internName = cast(getChildByName(AssetName.INTERN_POPIN_NAME), TextSprite);
		side.text = "GDP";
		internName.text = "Alexis";
		
		//btnSend = cast(getChildByName("Bouton_InternSend_Clip"), SmartButton);
		//btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		//btnSeeAll = cast(getChildByName("Bouton_AllInterns_Clip"), SmartButton);
		var interMc:SmartComponent = cast(getChildByName(AssetName.INTERN_POPIN_SEE_ALL_CONTAINER), SmartComponent);
		btnSeeAll = cast(interMc.getChildByName(AssetName.INTERN_POPIN_SEE_ALL), SmartButton);
		
		btnClose = cast(getChildByName(AssetName.INTERN_POPIN_CANCEL), SmartButton);
		
		btnClose.on(MouseEventType.CLICK, onClose);
		btnSeeAll.on(MouseEventType.CLICK, onSeeAll);
	}
	
	private function onClose(){
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onSeeAll(){
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	override public function destroy():Void 
	{
		btnSeeAll.off(MouseEventType.CLICK, onSeeAll);
		btnClose.off(MouseEventType.CLICK, onClose);
		super.destroy();
	}
	
}