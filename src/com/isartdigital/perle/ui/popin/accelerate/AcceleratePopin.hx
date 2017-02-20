package com.isartdigital.perle.ui.popin.accelerate;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class AcceleratePopin extends SmartPopinExtended
{

	private var price:Int;
	private var progressBarTxt:TextSprite;
	private var btn:SmartButton;
	private var btnClose:SmartButton;
	private var ref:Int;
	private var actionTxt:TextSprite;
	
	public function new() 
	{
		Hud.getInstance().hide();
		super(AssetName.CONFIRMATION_ACCELERATE_POPIN);
		actionTxt = cast(getChildByName(AssetName.CONFIRMATION_ACCELERATE_POPIN_TEXT_ACTION), TextSprite);
		btn = cast(getChildByName(AssetName.CONFIRMATION_ACCELERATE_POPIN_BTN), SmartButton);
		btnClose = cast(getChildByName(AssetName.BTN_CLOSE), SmartButton);
		var interMc:SmartComponent = cast(getChildByName(AssetName.CONFIRMATION_ACCELERATE_POPIN_GAUGE), SmartComponent);
		progressBarTxt = cast(interMc.getChildByName(AssetName.TIME_GAUGE_TEXT), TextSprite);
		
		Interactive.addListenerClick(btn, onAccelerate);
		Interactive.addListenerRewrite(btn, rewriteBtn);
		Interactive.addListenerClick(btnClose, onClose);
		
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
		
		rewriteBtn();
	}
	
	private function rewrite(?pData:Dynamic):Void {
		
	}
	
	private function rewriteBtn():Void {
		var txt:TextSprite = cast(btn.getChildByName(AssetName.TIME_ACCELERATE_BUTTON_TXT), TextSprite);
		txt.text = price + "";
	}
	
	private function onAccelerate():Void{
		rewriteBtn();
		if (ResourcesManager.getTotalForType(GeneratorType.hard) - price < 0) return;
		
		ResourcesManager.spendTotal(GeneratorType.hard, price);
		SoundManager.getSound("SOUND_KARMA").play();
	}
	
	private function onClose():Void {
		if (DialogueManager.passFree)
			return;
		
		UIManager.getInstance().closePopin(this);
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btn, onAccelerate);
		Interactive.removeListenerRewrite(btn, rewriteBtn);
		Interactive.removeListenerRewrite(btnClose, onClose);
	}
	
}