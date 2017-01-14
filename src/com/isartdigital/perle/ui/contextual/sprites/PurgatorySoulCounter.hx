package com.isartdigital.perle.ui.contextual.sprites;

import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

typedef TextInformation = {
	var current:Float;
	var max:Float;
}
	
/**
 * ...
 * @author de Toffoli Matthias
 */
class PurgatorySoulCounter extends SmartComponent 
{
	
	/**
	 * instance unique de la classe PurgatorySoulCounter
	 */
	private static var instance: PurgatorySoulCounter;
	private var txt:TextSprite;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PurgatorySoulCounter {
		if (instance == null) instance = new PurgatorySoulCounter();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super("SoulsCounter_purgatory");
		
		txt = cast(SmartCheck.getChildByName(this, "_infos_purgatory_txt"), TextSprite);
		
	}
	
	public function setText(txtInfo:TextInformation):Void{
		txt.text = txtInfo.current + "/" + txtInfo.max;
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