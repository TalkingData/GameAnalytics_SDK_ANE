package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;
	
	import flash.media.Video;

	public class TDGAItem
	{
		
		public static function onPurchase(item:String,itemNumber:int,priceInVirtualCurrency:Number):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.ItemPurchse,item,itemNumber,priceInVirtualCurrency);
			}catch(err:Error){
				
			}
		}
		public static function onUse(item:String,itemNumber:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.ItemUse,item,itemNumber);
			}catch(err:Error){
				
			}
		}
	}
}