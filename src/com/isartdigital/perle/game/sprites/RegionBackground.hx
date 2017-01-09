package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.virtual.VTile.Index;

/**
 * class for region background can be sortes
 * @author de Toffoli Matthias
 */
class RegionBackground extends FlumpStateGraphic implements IZSortable
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
	
	public function new(pAssetName:String, pTilePos:Index, pMapSize:Index) 
	{
		super(pAssetName);
		setMapColRow(pTilePos, pMapSize);
		
	}
	
	/**
	 * 
	 * @param	pTilePos (TilePosition like if they were only one big region)
	 * @param	pMapSize size of the background
	 */
	private function setMapColRow(pTilePos:Index, pMapSize:Index):Void {
		colMax = pTilePos.x + pMapSize.x-1; // (0 en haut, 10 à droite)
		colMin = pTilePos.x;
		rowMax = pTilePos.y + pMapSize.y-1; // (0 en haut, 10 à gauche)
		rowMin = pTilePos.y;
	}
	
}