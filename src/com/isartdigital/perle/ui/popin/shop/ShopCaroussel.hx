package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.display.Container;
import pixi.core.math.Point;

	
/**
 * ...
 * @author ambroise & alexis
 */
class ShopCaroussel extends SmartComponent {
	
	// no json because i'm using constants
	// todo : utiliserBDD pour enregistrer cela
	public static var buildingNameList(default, never):Array<String> = [
		AssetName.BUILDING_HELL_HOUSE,//1 <== level required
		AssetName.BUILDING_HEAVEN_HOUSE,//1
		AssetName.DECO_HEAVEN_VERTUE,//2
		
		AssetName.LUMBERMIL_LEVEL1,//2
		AssetName.QUARRY_LEVEL_1,//2
	
		//AssetName.BUILDING_HEAVEN_BUILD_2,//2 <== Jai comenter ces lignes car on ne doit pas acheter les upgrades des batiments
		//AssetName.BUILDING_HELL_BUILD_2,//3
		//AssetName.BUILDING_HEAVEN_BUILD_1,//3
		
	];
	
	public static var decoNameList(default, never):Array<String> = [
		AssetName.DECO_HELL_TREE_1,//2
		AssetName.DECO_HEAVEN_TREE_1,//2
		AssetName.DECO_HEAVEN_FOUNTAIN,//3
		AssetName.DECO_HEAVEN_TREE_2,//4
		
		AssetName.DECO_HEAVEN_TREE_3,//4
		AssetName.DECO_HEAVEN_ROCK,//4
		AssetName.DECO_HELL_TREE_2,//4
		AssetName.DECO_HELL_TREE_3,//5
		
		AssetName.DECO_HELL_ROCK,//5
		
		//AssetName.BUILDING_HEAVEN_BRIDGE,
	];
	
	public static var internsNameList(default, never):Array<String> = [
	];
	
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
	
	public static var cardsToShow:Array<String>;
	private static var alreadyOpened:Bool = false;
	public static var lTab:String;
	private var cards:Array<CarouselCard>;
	
	private var tempArrowRight:SmartButton;
	private var tempArrowLeft:SmartButton;
	
	private var maxCardsVisible:Int;
	private var cardsPositions:Array<Point>;
	private var buildingListIndex:Int = 0;
	
	// used in UIBuilder.hx, Singleton ou pas ? nom plus précis, comme carousselBuilding etc
	// todo réutiliser pour d'autre éléments type shoCaroussel ?
	public function new(pTab:String) { 	
		lTab = pTab;
		checkIfDestroyNeeded();
		switch(pTab) {
			case "Building" : {
				super(AssetName.SHOP_CAROUSSEL_BUILDING); // todo:  temp ? ou change classNAme
				tempArrowLeft = cast(SmartCheck.getChildByName(this, "Button_ArrowLeft"), SmartButton); // temp
				tempArrowRight = cast(SmartCheck.getChildByName(this, "Button_ArrowRight"), SmartButton);
			}
			case "Resource" : {
				super(AssetName.SHOP_CAROUSSEL_RESOURCE);
				tempArrowLeft = cast(SmartCheck.getChildByName(this, "Arrow_Left_Wood"), SmartButton); // temp
				tempArrowRight = cast(SmartCheck.getChildByName(this, "Arrow_Right_Stone"), SmartButton);
			}
			/*case "Currencies": {
				super(AssetName.SHOP_CAROUSSEL_CURRENCIE);
				tempArrowLeft = cast(SmartCheck.getChildByName(this, "Arrow_Left_Hard"), SmartButton); // temp
				tempArrowRight = cast(SmartCheck.getChildByName(this, "Arrow_Right_Soft"), SmartButton);
			}*/
		}
	}
	
	public function init (pPos:Point,pTab:String):Void {
		
		
		cards = new Array<CarouselCard>();
		cardsToShow = buildingNameList;
		cardsPositions = [];
		
		position = pPos;
		
		switch(pTab) {
			case "Building" : createCard(getSpawnersPosition(getSpawners(getSpawnersAssetNames())));
			case "Resource" : createCard(getSpawnersPosition(getSpawners(getSpawnersResourceAssetName())));
			//case "Currencies":createCard(getSpawnersPosition(getSpawners(getSpawnersCurrenciesAssetName())));
		}
		
		
		alreadyOpened = true;
	}
	
	public function start ():Void {
		tempArrowLeft.on(MouseEventType.CLICK, onClickTempArrowLeft);
		tempArrowRight.on(MouseEventType.CLICK, onClickTempArrowRight);
		
	}
	
	public function changeCardsToShow (pNameList:Array<String>):Void {
		cardsToShow = pNameList;
		buildingListIndex = 0;
		createCard(cardsPositions);
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
		];
	}
	
	private function getSpawnersResourceAssetName():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Pack_1",
			"Shop_Pack_2",
			"Shop_Pack_3",
			"Shop_Pack_4",
			"Shop_Pack_5",
			"Shop_Pack_6",
		];
	}
	
	private function getSpawnersCurrenciesAssetName():Array<String> {
		return [ // todo : constantes ? c'est des spawners..
			"Shop_Pack_1",
			"Shop_Pack_2",
			"Shop_Pack_3",
			"Shop_Pack_4",
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
	
	
	private function createCard (pPositions:Array<Point>):Void {
		if (cards.length != 0)
			destroyCards();
		
		for (i in 0...pPositions.length) {
			var j:Int = i + buildingListIndex;
			
			if (cardsToShow[j] == null)
				break;
				
			if (lTab == "Building") {
				if (!UnlockManager.checkIfUnlocked(cardsToShow[j]))
					cards[i] = new CarousselCardLock();
				else 
					cards[i] = new CarousselCardUnlock();
			}
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
	
	private function checkIfDestroyNeeded():Void {
		if (alreadyOpened) {
			ShopPopin.getInstance().removeCaroussel();
		}
	}
	
	// todo : destroy les cards
	override public function destroy():Void {
		destroyCards();
		cards = null;
		alreadyOpened = false;
		super.destroy();
	}

}