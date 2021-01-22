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
import com.tendcloud.tenddata.TDGAProfile;
import com.tendcloud.tenddata.TDGAProfile.ProfileType;
import com.tendcloud.tenddata.TDGAProfile.Gender;

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
			case TDFunctionType.SetProfileID:
				String countID=arg1[1].getAsString();
				exContext.tdProfile=TDGAProfile.setProfile(countID);
				break;
			case TDFunctionType.SetProfile_Age:
				int age=arg1[1].getAsInt();
				exContext.tdProfile.setAge(age);
				break;
			case TDFunctionType.SetProfile_Gender:
				int gender=arg1[1].getAsInt();
				setGender(gender);
				break;
			case TDFunctionType.SetProfile_Level:
				int level=arg1[1].getAsInt();
				exContext.tdProfile.setLevel(level);
				break;
			case TDFunctionType.SetProfile_Name:
				String name=arg1[1].getAsString();
				exContext.tdProfile.setProfileName(name);
				break;
			case TDFunctionType.SetProfile_Server:
				String server=arg1[1].getAsString();
				exContext.tdProfile.setGameServer(server);
				break;
			case TDFunctionType.SetProfile_TYPE:
				int profile_type=arg1[1].getAsInt();
				setProfileType(profile_type);
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
				//TalkingDataGA.setPushDisabled();//没打push功能则需要注释掉
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
		exContext.tdProfile.setGender(g);
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
	private void setProfileType(int type){
		ProfileType at=ProfileType.ANONYMOUS;
		switch (type) {
		case 1:
			at=ProfileType.REGISTERED;
			break;
		case 2:
			at=ProfileType.SINA_WEIBO;
			break;
		case 3:
			at=ProfileType.QQ;		
			break;
		case 4:
			at=ProfileType.QQ_WEIBO;
			break;
		case 5:
			at=ProfileType.ND91;
			break;
		case 6:
			at=ProfileType.WEIXIN;
			break;
		case 11:
			at=ProfileType.TYPE1;
			break;
		case 12:
			at=ProfileType.TYPE2;
			break;
		case 13:
			at=ProfileType.TYPE3;
			break;
		case 14:
			at=ProfileType.TYPE4;
			break;
		case 15:
			at=ProfileType.TYPE5;
			break;
		case 16:
			at=ProfileType.TYPE6;
			break;
		case 17:
			at=ProfileType.TYPE7;
			break;
		case 18:
			at=ProfileType.TYPE8;
			break;
		case 19:
			at=ProfileType.TYPE9;
			break;
		case 20:
			at=ProfileType.TYPE10;
			break;
		default:
			
			break;
		}
		exContext.tdProfile.setProfileType(at);
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
