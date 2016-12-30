package com.isartdigital.perle.ui.contextual.virtual;

import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.VTile.Index;

/**
 * Is not saved, is not in clippingMap directly, it is contained by a HudContextual that itself
 * is in a VBuilding
 * @author ambroise
 */
class VirtualUI extends Virtual{

	private var positionClippingMap:Index;
	
	public function new() {
		super();
		
	}
	
	
	// élément statique, mais pas aligner à une tile de base, donc ?
	// faire un arrondi et basta ?
	private function addToClippingList ():Void {
		
		// calcule la nouvelle position
		var pPos:Index = {
			x:cast(ClippingManager.posToClippingMap(position).x, Int),
			y:cast(ClippingManager.posToClippingMap(position).y, Int)
		}
		
		// enlève de la clipping list si y est
		if (positionClippingMap != null &&
			positionClippingMap.x != pPos.x &&
			positionClippingMap.y != pPos.y)
			removeFromClippingList();
		
		// enregistre pour pouvoir enlever plus tard
		positionClippingMap = pPos;
		
		// vérifie que le tableau n'est pas vide
		if (clippingMap[pPos.x] == null)
			clippingMap[pPos.x] = new Map<Int, Array<Virtual>>();
		if (clippingMap[pPos.x][pPos.y] == null)
			clippingMap[pPos.x][pPos.y] = new Array<Virtual>();
		
		// changer ce commentaire :
		// array length should be max 2 if only ground and building can be on each other !
		// ajoute au tableau
		clippingMap[pPos.x][pPos.y].push(this);
	}
	
	private function removeFromClippingList ():Void {
		clippingMap[positionClippingMap.x][positionClippingMap.y].splice(
			clippingMap[positionClippingMap.x][positionClippingMap.y].indexOf(this),
			1
		);
	}
	
}