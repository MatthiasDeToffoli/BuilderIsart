package com.isartdigital.perle.ui.popin.accelerate;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.collector.CollectorPopin;
import com.isartdigital.perle.ui.popin.collector.TimerInProd;
import com.isartdigital.utils.sounds.SoundManager;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class AcceleratePopinCollector extends AcceleratePopin 
{
	
	/**
	 * instance unique de la classe AcceleratePopinCollector
	 */
	private static var instance: AcceleratePopinCollector;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): AcceleratePopinCollector {
		if (instance == null) instance = new AcceleratePopinCollector();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		price = CollectorPopin.getInstance().getTimer().getPrice();
		ref = CollectorPopin.getInstance().getTimer().getRef();
		super();
		actionTxt.text = "Accelerate collector production";
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION, rewrite);
		
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
	}
	
	override function onAccelerate():Void 
	{
		SoundManager.getSound("SOUND_KARMA").play();
		Hud.getInstance().show();
		super.onAccelerate();
		UIManager.getInstance().closePopin(CollectorPopin.getInstance());
		UIManager.getInstance().closeCurrentPopin();
		TimeManager.setProductionFine(ref);
	}
	
	override private function rewrite(?pData:Dynamic):Void {
		progressBarTxt.text = CollectorPopin.getInstance().getTimer().getBarText();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION, rewrite);
		instance = null;
		super.destroy();
	}

}