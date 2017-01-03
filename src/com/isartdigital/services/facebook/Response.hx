package com.isartdigital.services.facebook;
import com.isartdigital.services.facebook.events.FacebookEventType;

/**
 * @author Mathieu Anthoine
 */
typedef Response =
{
	var status:String;
	@:optional var authResponse:AuthResponse;
}