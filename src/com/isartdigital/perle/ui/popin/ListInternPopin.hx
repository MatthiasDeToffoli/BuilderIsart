package com.isartdigital.perle.ui.popin;

import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.DisplayObject;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class ListInternPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe InternPopin
	 */
	private static var instance: ListInternPopin;
	
	private var btnClose:SmartButton;
	private var btnLeft:UISprite;
	private var btnRight:UISprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ListInternPopin {
		if (instance == null) instance = new ListInternPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super("ListInterns");
		
		for (i in 0...children.length) 
			trace (children[i].name);
			
			btnClose = cast(getChildByName("ButtonCancel"), SmartButton);
			//Uisprite pas de box pour des boutons ? Oo @TODO voir avec les GD
			btnLeft = cast(getChildByName("_arrow_left"), UISprite);
			btnRight = cast(getChildByName("_arrow_right"), UISprite);

			
			btnClose.on(MouseEventType.CLICK, onClose);
	}
	
	private function onLeft(){
		trace("left");
	}
	
	private function onRight(){
		trace("right");
	}
	
	private function onClose(){
		Hud.getInstance().addToContainer();
		destroy();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		parent.removeChild(this);
		super.destroy();
	}

}