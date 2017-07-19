package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;

	public class TDGAVirtualCurrency
	{
		
		public static var CNY:String="CNY";
		public static var USD:String="USD";
		public static var EUR:String="EUR";
		
		public static function onChargeRequest(orderID:String,iapID:String,currencyAmount:Number,currencyType:String,virtualCurrencyAmout:Number,paymentType:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.ChargeRequest,orderID,iapID,currencyAmount,currencyType,virtualCurrencyAmout,paymentType);
			}catch(err:Error){
				
			}
		}
		
		public static function onChargeSuccess(orderID:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.ChargeSuccess,orderID);
			}catch(err:Error){
				
			}
		}
		
		public static function onReward(virtualCurrencyAmount:Number,reason:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.OnReward,virtualCurrencyAmount,reason);
			}catch(err:Error){
				
			}
		}
	}
}