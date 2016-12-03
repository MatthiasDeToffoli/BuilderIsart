package com.isartdigital.perle.game.managers;

	
/**
 * Interface whit the server
 * @author ambroise
 */
class ServerManager {
	
	/**
	 * instance unique de la classe ServerManager
	 */
	private static var instance: ServerManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ServerManager {
		if (instance == null) instance = new ServerManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}