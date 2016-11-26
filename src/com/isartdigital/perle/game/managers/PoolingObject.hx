package com.isartdigital.perle.game.managers;

/**
 * @author ambroise
 */
interface PoolingObject {
	public function init():Void;
	public function recycle():Void;
	public function destroy():Void;
}