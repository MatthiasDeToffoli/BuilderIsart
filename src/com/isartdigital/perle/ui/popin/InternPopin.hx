package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.utils.Interactive;
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
class InternPopin extends SmartPopinExtended
{

	private var side:TextSprite;
	private var internName:TextSprite;
	private var btnSend:SmartButton;
	private var btnDismiss:SmartButton;
	private var btnSeeAll:SmartButton;
	private var btnClose:SmartButton;
	
	public function new(pIntern:InternDescription) 
	{
		super(AssetName.INTERN_POPIN);
			
		side = cast(getChildByName(AssetName.INTERN_POPIN_SIDE), TextSprite);
		internName = cast(getChildByName(AssetName.INTERN_POPIN_NAME), TextSprite);
		side.text = pIntern.aligment;
		internName.text = pIntern.name;
		
		//btnSend = cast(getChildByName("Bouton_InternSend_Clip"), SmartButton);
		//btnDismiss = cast(getChildByName("Bouton_InternDismiss_Clip"), SmartButton);
		//btnSeeAll = cast(getChildByName("Bouton_AllInterns_Clip"), SmartButton);
		
		btnClose = cast(getChildByName(AssetName.INTERN_POPIN_CANCEL), SmartButton);
		
		Interactive.addListenerClick(btnClose, onClose);
		Interactive.addListenerClick(btnSeeAll, onSeeAll);
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
		Interactive.removeListenerClick(btnClose, onClose);
		Interactive.removeListenerClick(btnSeeAll, onSeeAll);
		super.destroy();
	}
	
}