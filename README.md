## TalkingData Game Analytics ANE SDK
Game Analytics ANE 平台 SDK 由`封装层`和 `Native SDK` 两部分构成，目前GitHub上提供了封装层代码，需要从 [TalkingData官网](https://www.talkingdata.com/spa/sdk/#/config) 下载最新版的 Android 和 iOS 平台 Native SDK，组合使用。

### 目录简介

- LibAne_Game	：Flex Library项目。

- LibBuild_Game	：用于编译ane的主要目录。

- LibIOS_Game：用于生成iOS静态库的Xcode工程。

- LibJava_Game：用于生成jar文件的Flash Builder/Eclipse工程。

### 集成说明
1. 下载本项目（封装层）到本地；  
2. 访问 [TalkingData官网](https://www.talkingdata.com/spa/sdk/#/config) 下载最新版的 Android 和 iOS 平台 Game Analytics SDK（ Native SDK）
	- 方法1：选择 Flash Air 平台进行功能定制；
	- 方法2：分别选择 Android 和 iOS 平台进行功能定制，请确保两个平台功能项一致；  
	![](/image/apply.png)
3. 将下载的最新版 `Native SDK` 复制到`封装层`中，并按照 [打包ANE](#pkgANE) 方式打包，构成完整的 ANE SDK。  
	- Android 平台  
	将最新的 .jar 文件复制到 `LibBuild_Game` 目录下
	- iOS 平台  
	将最新的 .a 文件复制到 `LibBuild_Game` 目录下
4. 按 `Native SDK` 功能选项对`封装层`代码进行必要的删减，详见“注意事项”第2条；
5. 将 ANE SDK 集成您需要统计的工程中，并按 [集成文档](http://doc.talkingdata.com/posts/34) 进行必要配置和功能调用。

### 注意事项
1. 分别选择 Android 和 iOS 平台进行功能定制时，请确保两个平台功能项一致。
2. 如果申请 Native SDK 时只选择了部分功能，则需要在本项目中删除未选择功能对应的封装层代码。  
	a) 如未选择`自定义事件`功能则删除以下部分  
	删除 `LibAne_Game/src/com/talkingdata/game/TalkingDataGA.as` 文件中如下代码：

	
		public static function onEvent(eventID:String,map:TDCustomEvent):void
		{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			var value:String=map.toTDString();
			extContext.call(functionName,GameFunctionType.CusEvent,eventID,value);
			}catch(err:Error){

			}
		}

	删除 LibBuild_Game/TalkingDataGA.h 文件中如下代码：

		+ (void)onEvent:(NSString *)eventId eventData:(NSDictionary *)eventData;

	b) 未选择`推送营销`功能则删除以下部分
	删除 LibBuild_Game/TalkingDataGA.h 文件中如下代码：

		+ (void)setDeviceToken:(NSData *)deviceToken;
		+ (BOOL)handleTDGAPushMessage:(NSDictionary *)message;
	

### <a name="pkgANE" ></a> 准备工作

**Android:**

1. 导入LibJava_Game到Flash Builder中。为此项目添加外部依赖包：

	![](/image/importJar.png)

 	- FlashRuntimeExtensions.jar：
 
		在Air SDK目录下，如 C:\Program Files\Adobe\Adobe Flash Builder 4.7 (64 Bit)\sdks\21.0\lib\android\FlashRuntimeExtensions.jar。

 	- TalkingData_Game_Analytics_SDK.jar：
 
		在TalkingData官网中下载。

 	- android.jar：

		在Android SDK的platforms目录下，如C:\Program Files\Android\sdk\platforms\android-25\android.jar。

2. 添加依赖后，Clean Project。

3. 然后右键点击项目，导出Jar文件,并重命名为 libjava_game.jar。

4. 把导出的libjava_game.jar放到LibBuild_Game文件夹下。
 
5. 使用jar命令合并Game_Analytics_SDK_Android_V3.x.xx.jar和刚刚导出的jar包：

		mkdir tmp
		cd tmp
		jar -xvf 　../libjava_game.jar
		jar -xvf 　../Game_Analytics_SDK_Android_Vx.x.xx.jar
		jar -cvf  LibGame.jar .

确保合并后的jar包名为LibGame.jar，如不是，请重命名为LibGame.jar。把LibGame.jar放在LibBuild_Game目录下的Android-ARM文件夹下。

**iOS:**

1. 导入LibIOS_Game目录下的工程到Xcode中。

2. 导入TalkingDataGA.h和libTalkingDataGA.a两个文件到Xcode工程中。

3. 确保您的Build Configuration为Release状态。
	![](/image/XcodeBuildConfig.png)

4. 先选择设备类型为iPhone ，执行 command + B，会在Products目录下生成对应的libLibIOS_Game.a包；再选择设备类型为iPhoneSimulator，执行 command + B，也会在Products目录下生成对应的libLibIOS_Game.a包。如下图：

	![](/image/generateLib.png)

5. 使用命令将两个静态库合并：

		lipo -create [iPhone类型的静态库路径] [iPhoneSimulator类型的静态库路径] -output [输出路径]
		
		//例如
		lipo -create /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphoneos/libLibIOS_Game.a /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphonesimulator/libLibIOS_Game.a  -output /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/libLibIOS_Game.a

把合成后的libLibIOS_Game.a静态库重命名为 libGameAnalytics.a ，并放到LibBuild_Game目录下的iPhone-ARM文件夹下。


#### 打包ANE

**进入到LibBuild_Game目录：**

1. 修改extension.xml中的namespace的版本号。如

		<extension xmlns="http://ns.adobe.com/air/extension/30.0">

	把 30.0 替换为本地adt版本。

2. 修改iPhone-ARM文件夹下的platform.xml中的namespace的版本号。如

		<platform xmlns="http://ns.adobe.com/air/extension/30.0">

	把 30.0 替换为本地adt版本。



3. 打开终端，进入到Build目录下，执行：
		
		adt -package -storetype pkcs12 -keystore [您的p12证书名] -storepass [您的证书密码] -target ane com.talkingdata.game.ane extension.xml -swc LibAne_Game.swc -platform Android-ARM -C Android-ARM . -platform iPhone-ARM -C iPhone-ARM . -platform default -C default .
	
		//例如
		adt -package -storetype pkcs12 -keystore Certificates.p12 -storepass 111 -target ane com.talkingdata.game.ane extension.xml -swc LibAne_Game.swc -platform Android-ARM -C Android-ARM . -platform iPhone-ARM -C iPhone-ARM . -platform default -C default .



执行完成后，会在Build目录下生成名为 com.talkingdata.game.ane 的包，ane打包完成。


### 集成 TalkingData 推送营销功能

#### Android:

在您的应用的配置文件（例如 `XXXXDemo-app.xml`）的 Android 节点中添加如下配置，SDK在启动时就会默认启用推送功能：

	<android>
        <colorDepth>16bit</colorDepth>
        <manifestAdditions><![CDATA[
			<manifest android:installLocation="auto">
				<uses-sdk android:minSdkVersion="10" android:targetSdkVersion="19" />

				<!----------------------------需添加的配置 start------------------------------->

                <uses-permission android:name="android.permission.INTERNET"/>
                <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
                <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
                <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
                <!-- 允许App开机启动，来接收推送 -->
				<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"></uses-permission>
				<!--发送持久广播 -->
				<uses-permission android:name="android.permission.BROADCAST_STICKY"></uses-permission>
				<!-- 修改全局系统设置-->
				<uses-permission android:name="android.permission.WRITE_SETTINGS"></uses-permission>
				<!-- 允许振动，在接收推送时提示客户 -->
				<uses-permission android:name="android.permission.VIBRATE"></uses-permission>
				<!-- 侦测Wifi 变化，以针对不同 Wifi 控制最佳心跳频率，确保push的通道稳定 -->
				<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
				<!-- 此权限用于在接到推送时，可唤醒屏幕，可选择性添加权限 -->
				<uses-permission android:name="android.permission.WAKE_LOCK"></uses-permission>
                
                
                <application>
	                <service android:name="com.gametalkingdata.push.service.PushService" android:process=":push" android:exported="true"></service>
	                <receiver android:name="com.gametalkingdata.push.service.PushServiceReceiver" android:exported="true">
					<intent-filter>
					    <action android:name="android.intent.action.CMD"></action>
					    <action android:name="android.talkingdata.action.notification.SHOW"></action>
					    <action android:name="android.talkingdata.action.media.MESSAGE"></action>
					    <action android:name="android.intent.action.BOOT_COMPLETED"></action>
					    <action android:name="android.net.conn.CONNECTIVITY_CHANGE"></action>
					    <action android:name="android.intent.action.USER_PRESENT"></action>
					</intent-filter>
					</receiver>
					<receiver android:name="com.tendcloud.tenddata.TalkingDataMessageReceiver" android:enabled="true">
					<intent-filter>
					    <action android:name="android.talkingdata.action.media.SILENT"></action>
					    <action android:name="android.talkingdata.action.media.TD.TOKEN"></action>
					</intent-filter>
					<intent-filter>
					    <action android:name="com.talkingdata.notification.click"></action>
					    <action android:name="com.talkingdata.message.click"></action>
					</intent-filter>
					</receiver>
                </application>
               
				<!----------------------------需添加的配置 end------------------------------->
            </manifest>
			
		]]></manifestAdditions>
    </android>


#### iOS:

1. 确认应用的 id 和您在 Apple 开发者官网上申请的应用的 Bundle ID 保持一致。

2. 在您的应用的配置文件（例如 `XXXXDemo-app.xml`）的 iPhone 节点中添加如下配置：

		<iPhone>
	        <InfoAdditions><![CDATA[
				<key>UIDeviceFamily</key>
				<array>
					<string>1</string>
					<string>2</string>
				</array>
			]]></InfoAdditions>
			
			<!------------------需添加的配置 start------------------------>
	
			<Entitlements><![CDATA[ 
	            <key>aps-environment</key> 
				<!-- 如果应用为生产环境，则将 development 替换为 production -->
	            <string>development</string> 
	        ]]></Entitlements> 
	
			<!------------------需添加的配置 end------------------------>
	
	        <requestedDisplayResolution>high</requestedDisplayResolution>
	    </iPhone>

3. 在应用中添加获取 deviceToken 流程：

		package
		{
			import com.talkingdata.game.TDCustomEvent;
			import com.talkingdata.game.TalkingDataGA;
			
			import flash.display.Sprite;
			import flash.display.StageAlign;
			import flash.display.StageScaleMode;
			import flash.events.Event;
			import flash.events.RemoteNotificationEvent;
			import flash.notifications.RemoteNotifier;
			import flash.notifications.RemoteNotifierSubscribeOptions;
		
		
			public class DemoApp extends Sprite
			{
		
				private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions(); 
				private var remoteNot:RemoteNotifier = new RemoteNotifier();
			
				public function DemoApp()
				{
					super();
				
					stage.align = StageAlign.TOP_LEFT;
					stage.scaleMode = StageScaleMode.NO_SCALE;
				
					TalkingDataGA.onStart("08111CC162F442038E191C8472A0FE9A","talkingdata");
							
					remoteNot.addEventListener(RemoteNotificationEvent.TOKEN, tokenHandler);
					this.stage.addEventListener(Event.ACTIVATE, activateHandler);
				}
			
				public function activateHandler(e:Event):void{ 
					if(RemoteNotifier.supportedNotificationStyles.toString() != "") 
					{     
						// Before subscribing to push notifications, ensure the device supports it. 
                        // supportedNotificationStyles returns the types of notifications 
                        // that the OS platform supports 
						remoteNot.subscribe(subscribeOptions); 
					} 
				} 
			
				public function tokenHandler(e:RemoteNotificationEvent):void
				{
					// If the subscribe() request succeeds, a RemoteNotificationEvent of 
                    // type TOKEN is received, from which you retrieve e.tokenId,
					// which you use to register with TalkingData SDK.
					com.talkingdata.game.TalkingDataGA.setDeviceToken(e.tokenId);
				}
			
			}
		}

4. 在 Apple 开发者官网上确认您的应用开启了 Push Notifications 功能。

	<img src="/image/push_enable.png" />

5. 将应用对应的推送证书导出为 p12 格式， 并在 TalkingData 官网上的推送配置中上传证书。

	<img src="/image/iOS_push_configuration.png" />



**注： iOS 推送暂时无法统计 “进入应用” 指标。**

