package com.isartdigital.perle.game.iso;

/**
 * Interface des objets à "z sorter"
 * @author Mathieu Anthoine
 */
interface IZSortable 
{
	
	// colonne minimum
	public var colMin:Int;
	
	// colonne maximum
	public var colMax:Int;
	
	// ligne minimum
	public var rowMin:Int;
	
	// ligne maximum
	public var rowMax:Int;
	
	// tableau des élements placés derrière
	public var behind:Array<IZSortable>;
	
	// tableau des éléments placés devant
	public var inFront:Array<IZSortable>;
}