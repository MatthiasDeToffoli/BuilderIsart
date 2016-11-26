package  {
	
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.utils.ByteArray;	
	
	public class ExportBoxes extends MovieClip {
		
		private var content:Object;
		private var file: FileReference;
		
		public function ExportBoxes() {
			
			content={};
			file = new FileReference();
			
			var lBox;
			// constructor code
			for (var i:int = 0; i<numChildren;i++) {
				lBox=getChildAt(i);
				if (lBox is DisplayObjectContainer) {
					content[getQualifiedClassName(lBox)]={};
					browseBox (content[getQualifiedClassName(lBox)],lBox);
				}
			}
			
			
			//trace (JSON.stringify(content,null,"\t"));
			
			var lData:ByteArray = new ByteArray();
			lData.writeMultiByte(JSON.stringify(content,null,"\t"), "utf-8" );
			file.save(lData, "boxes.json" );

		}
		
		private function browseBox (pContent:Object,pClip:DisplayObjectContainer): void {
			var lItem;
			
			for (var i:int=0;i<pClip.numChildren;i++) {
				lItem=pClip.getChildAt(i);
				
				var lClass:String=getQualifiedClassName(lItem);
		
				if (lClass!="Circle" && lClass!="Rectangle" && lClass!="Point") continue;
				
				if (lClass=="Circle" && Math.abs(lItem.width-lItem.height)>1) lClass="Ellipse";
				
				if (lClass=="Rectangle") setItem(pContent,lItem.name,lItem.getBounds(pClip).left,lItem.getBounds(pClip).top,lClass);
				else setItem(pContent,lItem.name,lItem.x,lItem.y,lClass);
				
				if (lClass=="Ellipse" || lClass=="Rectangle") {
					pContent[lItem.name].width=lItem.width;
					pContent[lItem.name].height=lItem.height;
				} else if (lClass=="Circle") pContent[lItem.name].radius=lItem.width/2;
	
			}
			
		}
		
		private function setItem (pContent:Object,pName:String,pX:Number,pY:Number,pType:String): void {
			pContent[pName]={};
			pContent[pName].x=pX;
			pContent[pName].y=pY;
			pContent[pName].type=pType;
		}
		
	}
	
}
