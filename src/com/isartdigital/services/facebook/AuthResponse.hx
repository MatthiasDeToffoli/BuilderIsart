package com.isartdigital.services.facebook;

/**
 * @author Mathieu Anthoine
 */
typedef AuthResponse =
{
	var accessToken: String;
    var expiresIn: String;
    var signedRequest: String;
    var userID: String;
}