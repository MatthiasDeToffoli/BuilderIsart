package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

	
/**
 * ...
 * @author ambroise & alexis
 */
class ShopCaroussel extends SmartComponent {
	
	
	public static var resourcesNameList(default, never):Array<String> = [
		"Wood pack",
		"Iron pack"
	];
	
	public static var currencieNameList(default, never):Array<String> = [
		"Gold pack",
		"Karma pack",
	];
	
	public static var bundleNameList(default, never):Array<String> = [
	];
	
	private var cardsToShow:Array<String>;
	private var cards:Array<CarouselCard>;
	private var arrowRight:SmartButton;
	private var arrowLeft:SmartButton;
	private var maxCardsVisible:Int;
	private var cardsPositions:Array<Point>;
	private var buildingListIndex:Int = 0;
	
	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	// todo réutiliser pour d'autre éléments type shoCaroussel ?
	public function new (pID:String=null) { 
		super(pID);
	}
	
	public function init (pPos:Point):Void {
		initArrows();
		cardsToShow = getCardToShow();
		cards = new Array<CarouselCard>();
		cardsPositions = [];
		
		position = pPos;
		
		if (cardsToShow != null)
			createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
		else
			Debug.error("No cards to show, it must be setted before super.init()");
	}
	
	public function scrollNext ():Void {
		if ((buildingListIndex + maxCardsVisible) >= cardsToShow.length)
			buildingListIndex = 0;
		else
			buildingListIndex += maxCardsVisible;
			
		createCard(cardsPositions);
	}
	
	public function scrollPrecedent ():Void {
		if ((buildingListIndex - maxCardsVisible) < 0)
			buildingListIndex = cardsToShow.length - cardsToShow.length % maxCardsVisible;
		else
			buildingListIndex -= maxCardsVisible;
		
		createCard(cardsPositions);
	}
	
	private function initArrows ():Void {
		arrowLeft = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_ARROW_LEFT), SmartButton);
		arrowRight = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_ARROW_RIGHT), SmartButton);
		Interactive.addListenerClick(arrowLeft, onClickArrowLeft);
		Interactive.addListenerClick(arrowRight, onClickArrowRight);
	}
	
	private function onClickArrowLeft ():Void {
		scrollPrecedent();
	}
	
	private function onClickArrowRight ():Void {
		scrollNext();
	}
	
	private function getSpawnersAssetNames ():Array<String> {
		return [];
	}
	
	private function getSpawners (pAssetNames:Array<String>):Array<UISprite> {
		var lSpawners:Array<UISprite> = [];
		
		setMaxCard(pAssetNames.length);
		
		for (i in 0...pAssetNames.length) {
			lSpawners.push(cast(SmartCheck.getChildByName(this, pAssetNames[i]), UISprite));
		}
		
		return lSpawners;
	}
	
	private function setMaxCard (pMax:Int):Void {
		maxCardsVisible = pMax;
	}
	
	private function setCardsPosition (pPositions:Array<Point>):Void {
		cardsPositions = pPositions;
	}
	
	private function getSpawnersPosition (pSpawners:Array<UISprite>):Array<Point> {
		var lPositions:Array<Point> = [];
		
		for (i in 0...pSpawners.length) {
			var lPoint:Point = new Point();
			lPoint.copy(pSpawners[i].position);
			lPositions.push(lPoint);
		}
		
		setCardsPosition(lPositions);
		destroySpawners(pSpawners);
		
		return lPositions;
	}
	
	private function destroySpawners (pSpawners:Array<UISprite>):Void {
		var lLength:UInt = pSpawners.length;
		var j:UInt;
        for (i in 1...lLength +1) {
			j = lLength - i;
			removeChild(pSpawners[j]);
			pSpawners[j].destroy();
		}
	}
	
	
	private function createCard (pPositions:Array<Point>):Void {
		if (cards.length != 0)
			destroyCards();
		
		for (i in 0...pPositions.length) {
			var j:Int = i + buildingListIndex;
			
			if (cardsToShow[j] == null)
				break;
			
			cards[i] = getNewCard(cardsToShow[j]);
			
			cards[i].position = pPositions[i];
			cards[i].init(cardsToShow[j]);
			addChild(cards[i]);
			cards[i].start();
		}
	}
	
	private function getNewCard (pCardToShow:String):CarouselCard {
		return null;
	}
	
	private function getCardToShow ():Array<String> {
		return null;
	}
	
	private function destroyCards ():Void {
		var lLength:UInt = cards.length;
		var j:UInt;
        for (i in 1...lLength +1) {
			j = lLength - i;
			cards[j].destroy();
			cards.splice(j, 1);
        }
	}
	
	// todo : destroy les cards
	override public function destroy():Void {
		parent.removeChild(this);
		// those arrow are null on intern caroussel
		if (arrowLeft != null)
			Interactive.removeListenerClick(arrowLeft, onClickArrowLeft);
		if (arrowRight != null)
			Interactive.removeListenerClick(arrowRight, onClickArrowRight);
		destroyCards();
		cards = null;
		super.destroy();
	}

}