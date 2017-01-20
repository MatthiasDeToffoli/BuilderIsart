package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * bloc corresponding to the intern part in the listInternPopin
 * @author de Toffoli Matthias
 */
class InternElement extends SmartComponent
{

	private var internName:TextSprite;
	private var picture:SmartButton;
	
	public function new(pID:String=null, pPos:Point) 
	{
		super(pID);
		position = pPos;
		
	}
	
	private function onPicture(){
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(new InternPopin());
		
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(picture, onPicture);
		parent.removeChild(this);
		super.destroy();
	}
	
}