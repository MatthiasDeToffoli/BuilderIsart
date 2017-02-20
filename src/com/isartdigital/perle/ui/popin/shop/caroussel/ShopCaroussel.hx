package com.isartdigital.perle.ui.popin.shop.caroussel;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.ui.popin.shop.card.CarouselCard;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
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
	private var textPageNumber:TextSprite;
	private var maxCardsVisible:Int;
	private var cardsPositions:Array<Point>;
	private var buildingListIndex:Int = 0;
	private var myEnum:ShopTab;
	
	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	// todo réutiliser pour d'autre éléments type shoCaroussel ?
	public function new (pID:String=null) { 
		super(pID);
	}
	
	public function init (pPos:Point, pTab:ShopTab):Void {
		initArrows();
		cardsToShow = getCardToShow();
		cards = new Array<CarouselCard>();
		cardsPositions = [];
		
		position = pPos;
		myEnum = pTab;
		
		if (cardsToShow != null)
			createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
		else
			Debug.error("No cards to show, it must be setted before super.init()");
		
		setPageNumber();
		
		if (cardsToShow.length <= maxCardsVisible)
			destroyArrows();
	}
	
	private function destroyArrows ():Void {
		if (SmartCheck.getChildByName(this, "NavigArrowBG") != null) {
			var lArrowBG:UISprite = cast(SmartCheck.getChildByName(this, "NavigArrowBG"), UISprite);
			removeChild(lArrowBG);
			lArrowBG.destroy();
		}
		
		if (arrowRight != null) {
			removeChild(arrowRight);
			arrowRight.destroy();
			arrowRight = null;
		}
		
		if (arrowLeft != null) {
			removeChild(arrowLeft);
			arrowLeft.destroy();
			arrowLeft = null;
		}
		
		if (textPageNumber != null){
			removeChild(textPageNumber);
			textPageNumber.destroy();
			textPageNumber = null;
		}
	}
	
	public function scrollNext ():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		if ((buildingListIndex + maxCardsVisible) >= cardsToShow.length)
			buildingListIndex = 0;
		else
			buildingListIndex += maxCardsVisible;
			
		createCard(cardsPositions);
		setPageNumber();
	}
	
	public function scrollPrecedent ():Void {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		var lCorrection:Int = (cardsToShow.length % maxCardsVisible) == 0 ? -maxCardsVisible : 0;
		
		if ((buildingListIndex - maxCardsVisible) < 0)
			buildingListIndex = cardsToShow.length - (cardsToShow.length % maxCardsVisible) + lCorrection;
		else
			buildingListIndex -= maxCardsVisible;
		
		createCard(cardsPositions);
		setPageNumber();
	}
	
	private function setPageNumber ():Void {
		// is not inter tab and had more then one page.
		if (textPageNumber != null && cardsToShow.length > maxCardsVisible) {
			// when no rest on the division, there is gonna be one page more whitout correction
			var lCorrection:Int = (cardsToShow.length % maxCardsVisible) == 0 ? 0 : 1;
			var lCurrentPage:Float = 1 + (buildingListIndex - (buildingListIndex % maxCardsVisible)) / maxCardsVisible;
			var lMaxPage:Float =  lCorrection + (cardsToShow.length - (cardsToShow.length % maxCardsVisible)) / maxCardsVisible;
			
			textPageNumber.text = lCurrentPage + "/" + lMaxPage;
		}
	}
	
	/*private function getExceedent (pInt1:Int, pMax:Int):Int {
		return (pInt1 % pMax) == pInt1 ? 
	}*/
	
	private function initArrows ():Void {
		arrowLeft = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_ARROW_LEFT), SmartButton);
		arrowRight = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_ARROW_RIGHT), SmartButton);
		textPageNumber = cast(SmartCheck.getChildByName(this, AssetName.CAROUSSEL_ARROW_PAGE_NUMBER), TextSprite);
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
			
			if (cardsToShow[j] == null || cardsToShow[j] == "null")
				break;
			
			cards[i] = getNewCard(cardsToShow[j]);
			
			cards[i].position = pPositions[i];
			cards[i].init(cardsToShow[j]);
			addChild(cards[i]);
		}
	}
	
	private function getNewCard (pCardToShow:String):CarouselCard {
		return null;
	}
	
	private function getCardToShow ():Array<String> {
 		if (DialogueManager.ftueStepClickOnCard) {
 			return DialogueManager.getCardToShow(myEnum);
		}
 		return getCardToShowOverride();
 	}
 	
 	private function getCardToShowOverride ():Array<String> {
 		return new Array<String>();
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