//
//  TDAneExtension.m
//  LibIOS_Game
//
//  Created by vernon^3^ on 13-5-22.
//  Copyright (c) 2013年 talkingData. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "TalkingDataGA.h"


const int OnResume=20;
const int OnPause=21;

const  int SetProfileID=30;
const int SetProfile_TYPE=31;
const int SetProfile_Name=32;
const int SetProfile_Level=33;
const int SetProfile_Gender=34;
const int SetProfile_Age=35;
const int SetProfile_Server=36;

//int getProfileID=40;
//int getProfile_TYPE=41;
//int getProfile_Name=42;
//int getProfile_Level=43;
//int getProfile_Gender=44;
//int getProfile_Age=45;
//int getProfile_Server=46;

const int ChargeRequest=50;
const int ChargeSuccess =51;
const int Onreward=52;


const int ItemPurchse=60;
const int ItemUse=61;

const int MissionBegin=70;
const int MissionCompleted=71;
const int MissionFailed=72;

const int CusEvent=80;
const int SetDeviceToken=81;
const int cmdDeviceID=1;
const int isOpenDebugLog=2;
const int setLocation=3;

TDGAProfile *profileInstance;


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

void setPrivateProfileType(FREObject argv[]){
    int32_t type;
    FREGetObjectAsInt32(argv[1], &type);
    TDGAProfileType profileType=kProfileAnonymous;
    switch (type) {
        case 1:
            profileType=kProfileRegistered;
            break;
        case 2:
            profileType=kProfileSinaWeibo;
            break;
        case 3:
            profileType=kProfileQQ;
            break;
        case 4:
            profileType=kProfileTencentWeibo;
            break;
        case 5:
            profileType=kProfileND91;
            break;
		case 6:
            profileType=kProfileTypeWeiXin;
            break;
        case 11:
            profileType=kProfileType1;
            break;
        case 12:
            profileType=kProfileType2;
            break;
        case 13:
            profileType=kProfileType3;
            break;
        case 14:
            profileType=kProfileType4;
            break;
        case 15:
            profileType=kProfileType5;
            break;
        case 16:
            profileType=kProfileType6;
            break;
        case 17:
            profileType=kProfileType7;
            break;
        case 18:
            profileType=kProfileType8;
            break;
        case 19:
            profileType=kProfileType9;
            break;
        case 20:
            profileType=kProfileType10;
            break;
        default:
            
            break;
    }
    if (profileInstance) {
        [profileInstance setProfileType:profileType];
    }
}

void chargeFromClien(FREObject argv[]){
    uint32_t orderIDLen;
    const uint8_t *orderID;
    
    uint32_t iapIDLen;
    const uint8_t *iapID;
    
    double_t currencyAmount;
    
    uint32_t currencyTypeLen;
    const uint8_t *currencyType;
    
    double_t virtualCurrencyAmount;
    
    uint32_t paymentTypeLen;
    const uint8_t *paymentType;
    
    FREGetObjectAsUTF8(argv[1], &orderIDLen, &orderID);
    FREGetObjectAsUTF8(argv[2], &iapIDLen, &iapID);
    FREGetObjectAsDouble(argv[3], &currencyAmount);
    FREGetObjectAsUTF8(argv[4], &currencyTypeLen, &currencyType);
    FREGetObjectAsDouble(argv[5], &virtualCurrencyAmount);
    FREGetObjectAsUTF8(argv[6], &paymentTypeLen, &paymentType);
    
    [TDGAVirtualCurrency onChargeRequst:[NSString stringWithUTF8String:(char*)orderID] iapId:[NSString stringWithUTF8String:(char*)iapID] currencyAmount:currencyAmount currencyType:[NSString stringWithUTF8String:(char*)currencyType] virtualCurrencyAmount:virtualCurrencyAmount paymentType:[NSString stringWithUTF8String:(char*)paymentType]];
    
}

void onPurchase(FREObject argv[]){
    uint32_t ItemLen;
    const uint8_t *Item;
    
    int32_t number;
    double_t price;
    
    FREGetObjectAsUTF8(argv[1], &ItemLen, &Item);
    FREGetObjectAsInt32(argv[2], &number);
    FREGetObjectAsDouble(argv[3], &price);
    [TDGAItem onPurchase:[NSString stringWithUTF8String:(char*)Item] itemNumber:number priceInVirtualCurrency:price];
}

void onUse(FREObject argv[]){
    uint32_t ItemLen;
    const uint8_t *Item;
    
    int32_t number;
    
    FREGetObjectAsUTF8(argv[1], &ItemLen, &Item);
    FREGetObjectAsInt32(argv[2], &number);
    
    [TDGAItem onUse:[NSString stringWithUTF8String:(char*)Item] itemNumber:number];
}

void onReward(FREObject argv[]){
    double_t currencyAmount;
    
    uint32_t reasonLen;
    const uint8_t *reason;
    
    FREGetObjectAsDouble(argv[1], &currencyAmount);
    FREGetObjectAsUTF8(argv[2], &reasonLen, &reason);
    
    [TDGAVirtualCurrency onReward:currencyAmount reason:[NSString stringWithUTF8String:(char*)reason]];
}




FREObject GameAnalyticsFunctions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]){
    
    FREObject freObject=NULL;
    
    int command;
    
    //field about profile
    uint32_t appIDLen;
    uint32_t channelLen;
    const uint8_t * appID;
    const uint8_t * channel;
    
    uint32_t profileIDLen;
    const uint8_t *profileID;
    
    int32_t profileAge;
    int32_t profileGender;
    
    int32_t userLevel;
    
    uint32_t userNameLen;
    const uint8_t* userName;
    
    uint32_t serverNameLen;
    const uint8_t*serverName;
    
    uint32_t orderIDLen;
    const uint8_t *orderID;
    
    uint32_t missionIDLen;
    const uint8_t *missionID;
    
    uint32_t failedCauselen;
    const uint8_t *failedCause;
    
    uint32_t eventIDlen;
    const uint8_t *eventID;
    
    uint32_t eventStringLen;
    const uint8_t *eventString;
	
	uint32_t deviceTokenLen;
    const uint8_t *deviceToken;
    
    double_t latitude;
    double_t longitude;
    
    
    FREGetObjectAsInt32(argv[0], &command);
    switch (command) {
        case OnResume:
            FREGetObjectAsUTF8(argv[1], &appIDLen, &appID);
            FREGetObjectAsUTF8(argv[2], &channelLen, &channel);
            [TalkingDataGA onStart:[NSString stringWithUTF8String:(char*)appID] withChannelId:[NSString stringWithUTF8String:(char*)channel]];
            break;
        case OnPause:
            break;
        case SetProfileID:
            FREGetObjectAsUTF8(argv[1], &profileIDLen, &profileID);
            profileInstance=[TDGAProfile setProfile:[NSString stringWithUTF8String:(char*)profileID]];
            break;
        case SetProfile_Age:
            FREGetObjectAsInt32(argv[1], &profileAge);
            if (profileInstance) {
                [profileInstance setAge:profileAge];
            }
            break;
        case SetProfile_Gender:
            FREGetObjectAsInt32(argv[1], &profileGender);
            if (profileInstance) {
                TDGAGender gender=kGenderUnknown;
                if (profileGender==1) {
                    gender=kGenderMale;
                }else if(profileGender==2){
                    gender=kGenderFemale;
                }
                [profileInstance setGender:gender];
            }
            break;
        case SetProfile_Level:
            FREGetObjectAsInt32(argv[1], &userLevel);
            if(profileInstance){
                [profileInstance setLevel:userLevel];
            }
            break;
        case SetProfile_Name:
            FREGetObjectAsUTF8(argv[1], &userNameLen, &userName);
            if (profileInstance) {
                [profileInstance setProfileName:[NSString stringWithUTF8String:(char*)userName]];
            }
            break;
        case SetProfile_Server:
            FREGetObjectAsUTF8(argv[1], &serverNameLen,&serverName);
            if (profileInstance) {
                [profileInstance setGameServer:[NSString stringWithUTF8String:(char*)serverName]];
            }
            break;
        case SetProfile_TYPE:
            setPrivateProfileType(argv);
            break;
        case ChargeRequest:
            chargeFromClien(argv);
            break;
        case ChargeSuccess:
            FREGetObjectAsUTF8(argv[1], &orderIDLen, &orderID);
            [TDGAVirtualCurrency onChargeSuccess:[NSString stringWithUTF8String:(char*)orderID]];
            break;
        case Onreward:
            onReward(argv);
            break;
        case ItemPurchse:
            onPurchase(argv);
            break;
        case ItemUse:
            onUse(argv);
            break;
        case MissionBegin:
            FREGetObjectAsUTF8(argv[1], &missionIDLen, &missionID);
            [TDGAMission onBegin:[NSString stringWithUTF8String:(char*)missionID]];
            break;
        case MissionCompleted:
            FREGetObjectAsUTF8(argv[1], &missionIDLen, &missionID);
            [TDGAMission onCompleted:[NSString stringWithUTF8String:(char*)missionID]];
            break;
        case MissionFailed:
            FREGetObjectAsUTF8(argv[1], &missionIDLen, &missionID);
            FREGetObjectAsUTF8(argv[2], &failedCauselen, &failedCause);
            [TDGAMission onFailed:[NSString stringWithUTF8String:(char*)missionID] failedCause:[NSString stringWithUTF8String:(char*)failedCause]];
            break;
        case CusEvent:
            FREGetObjectAsUTF8(argv[1], &eventIDlen, &eventID);
            FREGetObjectAsUTF8(argv[2], &eventStringLen, &eventString);
            NSString *jsonString=[NSString stringWithUTF8String:(char*)eventString];
            id obj=nil;
            if (jsonString) {
                NSError* error = nil;
                obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            }
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [TalkingDataGA onEvent:[NSString stringWithUTF8String:(char*)eventID] eventData:obj];
            }
            break;
		case SetDeviceToken:
			FREGetObjectAsUTF8(argv[1], &deviceTokenLen, &deviceToken);
            NSString *token  = [NSString stringWithUTF8String:(char*)deviceToken];
			[TalkingDataGA setDeviceToken:(id)token];
			break;
        case cmdDeviceID:
            ;
            FRENewObjectFromUTF8(strlen([[TalkingDataGA getDeviceId] UTF8String])+1, (const uint8_t* )[[TalkingDataGA getDeviceId] UTF8String], &freObject);
            break;
        case isOpenDebugLog:
//            FREGetObjectAsInt32(argv[1], &isopenDebug);
//            if (isopenDebug>0) {
//                [TalkingDataGA setVerboseLogEnabled];
//            }
            break;
            
        case setLocation:
            FREGetObjectAsDouble(argv[1], &latitude);
            FREGetObjectAsDouble(argv[2], &longitude);
            [TalkingDataGA setLatitude:latitude longitude:longitude];
            break;
        default:
            break;
    }
//    uint32_t stringLen;
//    const uint8_t *message;
//    FREGetObjectAsUTF8(argv[0], &stringLen, &message);
//    FREGetob
//    
//    NSString * msg=[NSString stringWithUTF8String:(char*)message];
//    NSLog(@"message data is %@",msg);
    
    return freObject;
}


void TDGAContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet){
    *numFunctionsToTest=1;
    FRENamedFunction *func=(FRENamedFunction*)malloc(sizeof(FRENamedFunction) * 1);
    func[0].name=(const uint8_t*)"GameAnalyticsFunctions";
    func[0].functionData=NULL;
    func[0].function=&GameAnalyticsFunctions;
    *functionsToSet=func;
    
    [TalkingDataGA setSDKFramework:3];
    
}

void TDGAContextFinalizer(FREContext ctx){
    
}

void TDGAExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet){
    extDataToSet=NULL;
    *ctxInitializerToSet=&TDGAContextInitializer;
    *ctxFinalizerToSet=&TDGAContextFinalizer;
}



