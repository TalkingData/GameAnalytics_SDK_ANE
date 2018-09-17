package com.talkingdata.game;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.tendcloud.tenddata.TDGAAccount;
import com.tendcloud.tenddata.TDGAAccount.AccountType;
import com.tendcloud.tenddata.TDGAAccount.Gender;
import com.tendcloud.tenddata.TDGAItem;
import com.tendcloud.tenddata.TDGAMission;
import com.tendcloud.tenddata.TDGAVirtualCurrency;
import com.tendcloud.tenddata.TalkingDataGA;

public class GameAnalyticsFunctions implements FREFunction {

	GameAnalyticsContext exContext=null;
	public GameAnalyticsFunctions(GameAnalyticsContext exContext){
		this.exContext=exContext;
	}
	private String Tag="GameAnalyticsFunctions";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		FREObject obj=null;
//		Log.d(Tag, "command:------------------------->>>>>>>>>>>>>>>>");
		try {
			Activity ctx=arg0.getActivity();
			if(ctx==null){
				return FREObject.newObject("Activity is null");
			}
			int Command=arg1[0].getAsInt();
//			Log.d(Tag, "command:------------------------->>>>>>>>>>>>>>>>"+Command+" count:"+arg1.length);
			switch (Command) {
			case TDFunctionType.OnResume:
				String appID=arg1[1].getAsString();
				String partener=arg1[2].getAsString();
//				this.initSDK(ctx, appID, partener);
                                com.tendcloud.tenddata.game.dz.a = 3;
				TalkingDataGA.init(ctx, appID, partener);
				TalkingDataGA.onResume(ctx);
				obj=FREObject.newObject("onResume completed");
				break;
			case TDFunctionType.OnPause:
				TalkingDataGA.onPause(ctx);
				break;
			case TDFunctionType.SetAccountID:
				String countID=arg1[1].getAsString();
				exContext.tdAccount=TDGAAccount.setAccount(countID);
				break;
			case TDFunctionType.SetAccount_Age:
				int age=arg1[1].getAsInt();
				exContext.tdAccount.setAge(age);
				break;
			case TDFunctionType.SetAccount_Gender:
				int gender=arg1[1].getAsInt();
				setGender(gender);
				break;
			case TDFunctionType.SetAccount_Level:
				int level=arg1[1].getAsInt();
				exContext.tdAccount.setLevel(level);
				break;
			case TDFunctionType.SetAccount_Name:
				String name=arg1[1].getAsString();
				exContext.tdAccount.setAccountName(name);
				break;
			case TDFunctionType.SetAccount_Server:
				String server=arg1[1].getAsString();
				exContext.tdAccount.setGameServer(server);
				break;
			case TDFunctionType.SetAccount_TYPE:
				int account_type=arg1[1].getAsInt();
				setAccountType(account_type);
				break;
			case TDFunctionType.ChargeRequest:
				onChargeReques(arg1);
				break;
			case TDFunctionType.ChargeSuccess:
				onChargeSuccess(arg1);
				break;
			case TDFunctionType.Onreward:
				onReward(arg1);
				break;
			case TDFunctionType.ItemPurchse:
				onPurchase(arg1);
				break;
			case TDFunctionType.ItemUse:
				onItemUse(arg1);
				break;
			case TDFunctionType.MissionBegin:
				String beginID=arg1[1].getAsString();
				TDGAMission.onBegin(beginID);
				break;
			case TDFunctionType.MissionCompleted:
				String completeID=arg1[1].getAsString();
				TDGAMission.onCompleted(completeID);
				break;
			case TDFunctionType.MissionFailed:
				String fID=arg1[1].getAsString();
				String reason=arg1[2].getAsString();
				TDGAMission.onFailed(fID, reason);
				break;
			case TDFunctionType.CusEvent:
				Log.e(Tag, "CustomEvent:----->before");
				String eventID=arg1[1].getAsString();
				String value=arg1[2].getAsString();
				Log.e(Tag, "CustomEvent:----->"+value);
				TalkingDataGA.onEvent(eventID, createMap(value));
				break;
			case TDFunctionType.GetDeviceID:
				String deviceID=TalkingDataGA.getDeviceId(ctx);
				obj=FREObject.newObject(deviceID);
				break;
			case TDFunctionType.openDebugLog:
//				TalkingDataGA.DEBUG=true;
				break;
			case TDFunctionType.setPushDisabled:
				TalkingDataGA.setPushDisabled();
				break;
			case TDFunctionType.test:
				obj=FREObject.newObject("testGame");
				break;
			default:
				break;
			}
		} catch (IllegalStateException e) {
			Log.e(Tag, e.getMessage());
		} catch (FRETypeMismatchException e) {
			Log.e(Tag, e.getMessage());
		} catch (FREInvalidObjectException e) {
			Log.e(Tag, e.getMessage());
		} catch (FREWrongThreadException e) {
			Log.e(Tag, e.getMessage());
		}catch(Exception e){
			Log.e(Tag, e.getMessage());
		}
		return obj;
	}

	private void onReward(FREObject[] arg1) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException {
		double currencyAmount=arg1[1].getAsDouble();
		String reason=arg1[2].getAsString();
		TDGAVirtualCurrency.onReward(currencyAmount, reason);
	}

	private Map<String,Object> createMap(String s){
		try {
			JSONObject jsonObj=new JSONObject(s);
			Map<String, Object> map=new HashMap<String, Object>();
			Iterator keys = jsonObj.keys();
			while(keys.hasNext()){
				String key=(String)keys.next();
				map.put(key, jsonObj.get(key));
			}
			return map;
		} catch (JSONException e) {
			
		}
		return null;
	}
	
//	private void initSDK(Activity ac,String appID,String partener){
//		Method method = null;
//		try {
//			method = TalkingDataGA.class.getDeclaredMethod("init", new Class[]{Context.class,String.class,String.class});
//			method.setAccessible(true);
//			method.invoke(null, new Object[]{ac,appID,partener});
//		} catch (SecurityException e) {
//			Log.e(Tag, "initSDK:SecurityException------------------------->>>>>>>>>>>>>>>>"+e.getMessage());
//		} catch (NoSuchMethodException e) {
//			Log.e(Tag, "initSDK:NoSuchMethodException------------------------->>>>>>>>>>>>>>>>"+e.getMessage());
//		} catch (IllegalArgumentException e) {
//			Log.e(Tag, "initSDK:IllegalArgumentException------------------------->>>>>>>>>>>>>>>>"+e.getMessage());
//		} catch (IllegalAccessException e) {
//			Log.e(Tag, "initSDK:IllegalAccessException------------------------->>>>>>>>>>>>>>>>"+e.getMessage());
//			e.printStackTrace();
//		} catch (InvocationTargetException e) {
//			Log.e(Tag, "initSDK:InvocationTargetException------------------------->>>>>>>>>>>>>>>>"+e.getLocalizedMessage());
//		}
//	}
	
	private void setGender(int gender){
		Log.d(Tag, "Gender is "+gender);
		Gender g=Gender.UNKNOW;
		if(gender==1){
			g=Gender.MALE;
		}else if(gender==2){
			g=Gender.FEMALE;
		}
		exContext.tdAccount.setGender(g);
	}
	
	private void onPurchase(FREObject[] objs) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException{
		String item=objs[1].getAsString();
		int itemNumber=objs[2].getAsInt();
		double priceInVirtualCurrency=objs[3].getAsDouble();
		TDGAItem.onPurchase(item, itemNumber, priceInVirtualCurrency);
	}
	
	private void onItemUse(FREObject[] objs) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException{
		String item=objs[1].getAsString();
		int itemNumber=objs[2].getAsInt();
		TDGAItem.onUse(item, itemNumber);
	}
	
	/*
	 * 		
	public static var ANONYMOUS:int =0;
	public static var REGISTERED:int =1;
	public static var SINA_WEIBO:int =2;
	public static var QQ:int =3;
	public static var QQ_WEIBO:int =4;
	public static var ND91:int =5;
	public static var TYPE1:int =11;
	public static var TYPE2:int =12;
	public static var TYPE3:int =13;
	public static var TYPE4:int =14;
	public static var TYPE5:int =15;
	public static var TYPE6:int =16;
	public static var TYPE7:int =17;
	public static var TYPE8:int =18;
	public static var TYPE9:int =19;
	public static var TYPE10:int =20;
	 */
	private void setAccountType(int type){
		AccountType at=AccountType.ANONYMOUS;
		switch (type) {
		case 1:
			at=AccountType.REGISTERED;
			break;
		case 2:
			at=AccountType.SINA_WEIBO;
			break;
		case 3:
			at=AccountType.QQ;		
			break;
		case 4:
			at=AccountType.QQ_WEIBO;
			break;
		case 5:
			at=AccountType.ND91;
			break;
		case 6:
			at=AccountType.WEIXIN;
			break;
		case 11:
			at=AccountType.TYPE1;
			break;
		case 12:
			at=AccountType.TYPE2;
			break;
		case 13:
			at=AccountType.TYPE3;
			break;
		case 14:
			at=AccountType.TYPE4;
			break;
		case 15:
			at=AccountType.TYPE5;
			break;
		case 16:
			at=AccountType.TYPE6;
			break;
		case 17:
			at=AccountType.TYPE7;
			break;
		case 18:
			at=AccountType.TYPE8;
			break;
		case 19:
			at=AccountType.TYPE9;
			break;
		case 20:
			at=AccountType.TYPE10;
			break;
		default:
			
			break;
		}
		exContext.tdAccount.setAccountType(at);
	}

	private void onChargeSuccess(FREObject[] objs) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException{
		String orderID=objs[1].getAsString();
		TDGAVirtualCurrency.onChargeSuccess(orderID);
	}
	
	private void onChargeReques(FREObject[] objs) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException{
		String orderID=objs[1].getAsString();
		String iapId=objs[2].getAsString();
		double currencyAmount=objs[3].getAsDouble();
		String currcncyType=objs[4].getAsString();
		double virtualCurrencyAmount=objs[5].getAsDouble();
		String paymentType=objs[6].getAsString();
		TDGAVirtualCurrency.onChargeRequest(orderID, iapId, currencyAmount, currcncyType, virtualCurrencyAmount, paymentType);
	}
}
