package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.iso.IZSortable;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.Config;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

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
	
	override public function init():Void 
	{
		super.init();
		addIsoBox();
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
	
	private function addIsoBox ():Void {
		if (colMin != 0) addIsoBoxForNotStyx();
		else addIsoBoxForStyx();

		
	}
	
	private function addIsoBoxForNotStyx():Void {
		var lLocalBounds:Rectangle = getLocalBounds();
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
		var myGraphic:Graphics = new Graphics();
		var lLocalLeftFromModelToView:Float = -Tile.TILE_WIDTH / 2 * (colMax-colMin);
		var lLocalRightFromModelToView:Float = Tile.TILE_WIDTH / 2 * (rowMax-rowMin);
		
		myGraphic.beginFill(0x8800FF, Config.debug && Config.data.boxAlpha != null ? Config.data.boxAlpha:0);
		
		myGraphic.drawRect(
			lLocalLeftFromModelToView,
			lAnchor.y,
			lLocalRightFromModelToView - lLocalLeftFromModelToView,
			Tile.TILE_HEIGHT * (rowMax - rowMin) + 2*Tile.TILE_HEIGHT
		);
		myGraphic.endFill();
		
		isoBox = myGraphic;
		addChild(isoBox);
		
	}
	
	private function addIsoBoxForStyx():Void {
		var lLocalBounds:Rectangle = getLocalBounds();
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
		var myGraphic:Graphics = new Graphics();
		var lLocalLeftFromModelToView:Float = -Tile.TILE_WIDTH  * (colMax-colMin);
		var lLocalRightFromModelToView:Float = Tile.TILE_WIDTH / 2 * (rowMax-rowMin);
		
		myGraphic.beginFill(0x8800FF, Config.debug && Config.data.boxAlpha != null ? Config.data.boxAlpha:0);
		
		myGraphic.drawRect(
			lLocalLeftFromModelToView - lLocalBounds.width/2 - 2*Tile.TILE_WIDTH/3,
			lAnchor.y,
			lLocalBounds.width,
			height
		);
		myGraphic.endFill();
		
		isoBox = myGraphic;
		addChild(isoBox);
	}
	
}