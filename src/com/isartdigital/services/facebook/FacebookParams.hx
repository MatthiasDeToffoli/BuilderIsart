package com.isartdigital.services.facebook;

/**
 * @author Mathieu Anthoine
 */
typedef FacebookParams = {
	@:optional var appId : String;
	var xfbml : Bool;
	var version : String;
	@:optional var cookie : Bool;
}