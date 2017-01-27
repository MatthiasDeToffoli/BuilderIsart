package com.isartdigital.services.monetization;
import haxe.Json;

/**
 * Service Bancaire
 * @author Mathieu Anthoine
 */
class Bank
{
	/**
	 * enregistrer les achats inApp
	 * @param	pAmount montant de l'achat
	 * @param	pCallback fonction appelée au retour de l'information
	 */
	public static function deposit (pAmount:Float,pCallback:Dynamic->Void): Void {
		initService("deposit", pAmount, pCallback);
	}
	
	/**
	 * rembourser un trop percu
	 * @param	pAmount montant à rembourser
	 * @param	pCallback fonction appelée au retour de l'information
	 */
	public static function refund (pAmount:Float,pCallback:Dynamic->Void): Void {
		initService("refund", pAmount, pCallback);
	}	
	
	/**
	 * donne accès au total des revenus générés
	 * @param	pCallback fonction appelée au retour de l'information
	 */
	public static function account (pCallback:Dynamic->Void=null): Void {
		var lRequest:HttpService = new HttpService(pCallback);
		lRequest.addParameter("account", "");
		lRequest.request(true);
	}
	
	private static function initService (pService:String,pAmount:Dynamic,pCallback:Dynamic->Void):Void {
		var lRequest:HttpService = new HttpService(pCallback);
		if (pAmount <= 0) {
			lRequest.onData (Json.stringify({error: "zero or negative value forbidden", code: 21}));
			return;
		}
		lRequest.addParameter(pService, Std.string(pAmount));
		lRequest.request(true);
	}
	
}