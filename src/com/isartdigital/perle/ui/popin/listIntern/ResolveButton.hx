package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * ...
 * @author Emeline Berenguier
 */
class ResolveButton extends SmartButton
{

	private var resolveText:TextSprite;
	
	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonResolve");
		position = pPos;
		resolveText = cast(getChildByName("_Resolve_text"), TextSprite);
		resolveText.text = Localisation.getText("LABEL_LISTINTERN_RESOLVE_BUTTON");
		Interactive.addListenerRewrite(this, setText);
	}
	
	private function setText():Void{
		resolveText = cast(getChildByName("_Resolve_text"), TextSprite);
		resolveText.text = Localisation.getText("LABEL_LISTINTERN_RESOLVE_BUTTON");
	}
	override public function destroy():Void {
		Interactive.removeListenerRewrite(this, setText);
		removeAllListeners();
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}