package com.isartdigital.services.facebook;

/**
 * @author Mathieu Anthoine
 */
typedef Permissions =
{
	@:optional var auth_type:String;
	var scope:String;
	@:optional var return_scopes:Bool;
	@:optional var enable_profile_selector:Bool;
	@:optional var profile_selector_ids:Bool;
}