package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
/**
 * ...
 * @author ambroise
 */
class ShopCaroussel extends SmartComponent {
	
	// no json because i'm using constants
	// todo : utiliserBDD pour enregistrer cela
	public static var buildingNameList(default, never):Array<String> = [ // todo : c'est bugué ...
		AssetName.BUILDING_HEAVEN_HOUSE,//1
		AssetName.BUILDING_HELL_HOUSE,//1
		AssetName.BUILDING_HELL_BUILD_1,//2
		AssetName.BUILDING_HEAVEN_BUILD_2,//2
		
		AssetName.LUMBERMIL_LEVEL1,//2
		AssetName.BUILDING_HELL_BUILD_2,//3
		AssetName.BUILDING_HEAVEN_BUILD_1,//3
		AssetName.DECO_HEAVEN_VERTUE,//3
		
		//AssetName.BUILDING_HEAVEN_BRIDGE,
	];
	
	public static var decoNameList(default, never):Array<String> = [ // todo : c'est bugué ...
		AssetName.DECO_HELL_TREE_1,//2
		AssetName.DECO_HEAVEN_TREE_1,//2
		AssetName.DECO_HEAVEN_FOUNTAIN,//2
		AssetName.DECO_HEAVEN_TREE_2,//4
		
		AssetName.DECO_HEAVEN_TREE_3,//4
		AssetName.DECO_HEAVEN_ROCK,//4
		AssetName.DECO_HELL_TREE_2,//4
		AssetName.DECO_HELL_TREE_3,//5
		
		AssetName.DECO_HELL_ROCK//5
		
		//AssetName.BUILDING_HEAVEN_BRIDGE,
	];

	public static var cardsToShow:Array<String>;
	private var cards:Array<CarouselCard>;
	
	private var tempArrowRight:SmartButton;
	private var tempArrowLeft:SmartButton; // todo : les deux aroow seront ensemblent
	
	private var maxCardsVisible:Int;
	private var cardsPositions:Array<Point>;
	private var buildingListIndex:Int = 0;
	
	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	// todo réutiliser pour d'autre éléments type shoCaroussel ?
	public function new() { 	
		super(AssetName.SHOP_CAROUSSEL_BUILDING); // todo:  temp ? ou change classNAme
		cards = new Array<CarouselCard>();
		cardsPositions = [];
		
		tempArrowLeft = cast(SmartCheck.getChildByName(this, "Button_ArrowLeft"), SmartButton); // temp
		tempArrowRight = cast(SmartCheck.getChildByName(this, "Button_ArrowRight"), SmartButton);
	}
	
	public function init (pPos:Point):Void {
		position = pPos;
		createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
	}
	
	public function start ():Void {
		tempArrowLeft.on(MouseEventType.CLICK, onClickTempArrowLeft);
		tempArrowRight.on(MouseEventType.CLICK, onClickTempArrowRight);
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
	
	private function onClickTempArrowLeft ():Void {
		scrollPrecedent();
	}
	
	private function onClickTempArrowRight ():Void {
		scrollNext();
	}
	
	// todo : automatisé le paramètre en prenant le nom spawner puis ce qu'il y a après
	// todo : utilsier des spawner
	private function getSpawnersAssetNames ():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Item_Unlocked_1",
			"Shop_Item_Unlocked_2",
			"Shop_Item_Locked_1",
			"Shop_Item_Locked_2",
		];
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
	
	// todo : à faire, retiens le spositions pose intelligemment ? ou pas ? façon css ?
	private function createCard (pPositions:Array<Point>):Void {
		trace(buildingListIndex);
		if (cards.length != 0)
			destroyCards();
		
		for (i in 0...pPositions.length) {
			var j:Int = i + buildingListIndex;
			
			if (cardsToShow[j] == null)
				break;
			if (!UnlockManager.checkIfUnlocked(cardsToShow[j]))
				cards[i] = new CarousselCardLock();
			else 
				cards[i] = new CarousselCardUnlock();
				
			cards[i].position = pPositions[i];
			cards[i].init(cardsToShow[j]); // todo temp
			addChild(cards[i]);
			cards[i].start();
		}
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
		destroyCards();
		cards = null;
		
		super.destroy();
	}

}