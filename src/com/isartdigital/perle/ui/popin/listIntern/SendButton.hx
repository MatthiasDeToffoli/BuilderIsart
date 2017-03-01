package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Emeline Berenguier
 */
class SendButton extends SmartButton
{

	private var textBtn:TextSprite;
	
	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonSend");
		position = pPos;
		
		textBtn = cast(getChildByName("buttonSendText"), TextSprite);
		textBtn.text = Localisation.getText("LABEL_LISTINTERN_SEND_BUTTON");
		Interactive.addListenerRewrite(this, setText);
	}
	
	private function setText():Void{
		textBtn = cast(getChildByName("buttonSendText"), TextSprite);
		textBtn.text = Localisation.getText("LABEL_LISTINTERN_SEND_BUTTON");
	}
	
	override public function destroy():Void { // todo : destroy fonctionnel ?
		Interactive.removeListenerRewrite(this, setText);
		removeAllListeners();
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
}