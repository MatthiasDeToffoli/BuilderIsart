package com.isartdigital.services.monetization;

import com.isartdigital.services.monetization.HttpService;
import haxe.Http;
import haxe.Json;

	
/**
 * Service permettant de créer un porte monnaie par joueur des Builder
 * Le porte monnaie est partagé entre tous les Builder
 * @author Mathieu Anthoine
 */
class Wallet 
{	

	/**
	 * Retourne le montant du porte maonnaie virtuel de l'utilisateur
	 * @param	pMail mail de l'utilisateur
	 * @param	pCallback fonction appelée au retour de l'information
	 */
	public static function getMoney (pMail:String,pCallback:Dynamic->Void): Void {
		initService(pMail,pCallback).request(true);
	}
	
	/**
	 * Retire une somme au porte monnaie virtuel de l'utilisateur
	 * @param	pMail mail de l'utilisateur
	 * @param	pCallback fonction appelée au retour de l'information
	 */
	public static function buy (pMail:String, pAmount:Float,pCallback:Dynamic->Void): Void {
		var lRequest:HttpService = initService(pMail, pCallback);
					
		if (pAmount <= 0) {
			lRequest.onData (Json.stringify({error: "zero or negative value forbidden", code: 21}));
			return;
		}
		
		lRequest.addParameter("buy", Std.string(pAmount));
		lRequest.request(true);
	}
	
	private static function initService (pMail:String,pCallback:Dynamic->Void):HttpService {
		var lRequest:HttpService = new HttpService(pCallback);
		lRequest.addParameter("wallet", pMail);
		return lRequest;
	}
	


}