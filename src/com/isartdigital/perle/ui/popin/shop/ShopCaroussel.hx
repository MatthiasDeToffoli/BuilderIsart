package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
/**
 * ...
 * @author ambroise
 */
class ShopCaroussel extends SmartComponent {
	


	private var cards:Array<CarouselCard>;

	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	public function new(pID:String = null) { 	
		super(pID);
		
		cards = new Array<CarouselCard>();
	}
	
	public function init ():Void {
		createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
	}
	
	// todo : automatisé le paramètre en prenant le nom spawner puis ce qu'il y a après
	private function getSpawnersAssetNames ():Array<String> {
		return [
			AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED,
			"Shop_Item_Locked_1",
			"Shop_Item_Locked_2",
			"Shop_Item_Locked_3",
		];
	}
	
	private function getSpawners (pAssetNames:Array<String>):Array<SmartComponent> {
		var lSpawners:Array<SmartComponent> = [];
		
		for (i in 0...pAssetNames.length) {
			lSpawners.push(cast(SmartCheck.getChildByName(this, pAssetNames[i]), SmartComponent));
		}
		
		return lSpawners;
	}
	
	private function getSpawnersPosition (pSpawners:Array<SmartComponent>):Array<Point> {
		var lPositions:Array<Point> = [];
		
		for (i in 0...pSpawners.length) {
			var lPoint:Point = new Point();
			lPoint.copy(pSpawners[i].position);
			lPoint.x += 50; // todo : temp, pour que cela soit plus visible
			lPoint.y += 50;
			lPositions.push(lPoint);
		}
		
		destroySpawners(pSpawners);
		
		return lPositions;
	}
	
	private function destroySpawners (pSpawners:Array<SmartComponent>):Void {
		for (i in pSpawners.length -1...0) {
			pSpawners[i].destroy();
		}
	}
	
	// todo : à faire, retiens le spositions pose intelligemment ? ou pas ? façon css ?
	private function createCard (pPositions:Array<Point>):Void {
		var tempAssetName:Array<String> = [
			AssetName.HOUSE_HELL,
			"Factory",
			"Factory",
			"Factory"
		];
		
		for (i in 0...pPositions.length) {
			cards[i] = new CarouselCard();
			cards[i].position = pPositions[i];
			cards[i].init(tempAssetName[i]); // todo temp
			addChild(cards[i]);
			cards[i].start();
		}
	}
	
	// todo : destroy les cards

}