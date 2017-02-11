package com.isartdigital.perle.ui.popin.server;
import com.isartdigital.perle.game.TimesInfo;
import haxe.Timer;

	
/**
 * ...
 * @author de Toffoli Matthias
 */
class ServerConnexionPopin extends ServerPopin 
{
	
	/**
	 * instance unique de la classe ServerConnexionPopin
	 */
	
	public static var isOpen:Bool = false;
	private static var instance: ServerConnexionPopin;
	private var BASETEXT(default, never):String = "Try to connect at server";
	private var numberPoint:Int = 0;
	private var loop:Timer;
	private var TIME_LOOP(default, never):Int = 5 * TimesInfo.DECSEC;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ServerConnexionPopin {
		if (instance == null) instance = new ServerConnexionPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		loop = Timer.delay(setTextInLoop, TIME_LOOP); // todo : variable locale ? sûr ?
		loop.run = setTextInLoop;
		setTextInLoop();
		ServerConnexionPopin.isOpen = true;
	}
	
	private function setTextInLoop():Void {
		text.text = BASETEXT;
		
		var i:Int;
		
		for (i in 0...numberPoint) text.text += ".";
		
		if (numberPoint > 2) numberPoint = 0;
		else numberPoint++;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		loop.stop();
		instance = null;
		ServerConnexionPopin.isOpen = false;
		super.destroy();
	}

}