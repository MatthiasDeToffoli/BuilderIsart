package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.utils.events.MouseEventType;
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
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
	}
	
	private function onPicture(){
		GameStage.getInstance().getPopinsContainer().addChild(new InternPopin()); //@ TODO gérer le passage de la descritpion de l'intern
		ListInternPopin.getInstance().destroy();
	}
	
	override public function destroy():Void 
	{
		picture.off(MouseEventType.CLICK, onPicture);
		parent.removeChild(this);
		super.destroy();
	}
	
}