package com.isartdigital.perle.game.iso;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.shapes.Rectangle;

/**
 * Interface des objets à "z sorter"
 * @author Mathieu Anthoine
 */
interface IZSortable 
{
	/**
	 * retourne la zone de hit de l'objet (sous forme d'un getter)
	 */
	//public var hitBox(get, null):Container;
	public var isoBox:Graphics;
	
	public var isoRect:Rectangle;
	
	/**
	 * colonne minimum
	 */ 
	public var colMin:Int;
	
	/**
	 * colonne maximum
	 */ 
	public var colMax:Int;
	
	/**
	 * ligne minimum
	 */ 
	public var rowMin:Int;
	
	/**
	 * ligne maximum
	 */ 
	public var rowMax:Int;
	
	/**
	 * tableau des élements placés derrière
	 */ 
	public var behind:Array<IZSortable>;
	
	/**
	 * tableau des éléments placés devant
	 */ 
	public var inFront:Array<IZSortable>;
	
	/**
	 * destroy isoBox
	 */
	//private function onDestroyZSortable:Void->Void;
	
	/**
	 * recycle isoBox
	 */
	//private function onRecycleZSortable:Void->Void;
}