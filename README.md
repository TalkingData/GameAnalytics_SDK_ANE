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
	![](/apply.png)
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
	![](http://i2.muimg.com/579600/59305650afa9697e.png)

4. 先选择设备类型为iPhone ，执行 command + B，会在Products目录下生成对应的libLibIOS_Game.a包；再选择设备类型为iPhoneSimulator，执行 command + B，也会在Products目录下生成对应的libLibIOS_Game.a包。如下图：

	![](http://i2.muimg.com/579600/0cc14c9424cb64a2.png)

5. 使用命令将两个静态库合并：

		lipo -create [iPhone类型的静态库路径] [iPhoneSimulator类型的静态库路径] -output [输出路径]
		
		//例如
		lipo -create /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphoneos/libLibIOS_Game.a /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphonesimulator/libLibIOS_Game.a  -output /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/libLibIOS_Game.a

把合成后的libLibIOS_Game.a静态库重命名为 libGameAnalytics.a ，并放到LibBuild_Game目录下的iPhone-ARM文件夹下。


#### 打包ANE

**进入到LibBuild_Game目录：**

1. 修改extension.xml中的namespace的版本号。如

		<extension xmlns="http://ns.adobe.com/air/extension/24.0">

	把 24.0 替换为本地adt版本。

2. 修改iPhone-ARM文件夹下的platform.xml中的namespace的版本号。如

		<platform xmlns="http://ns.adobe.com/air/extension/24.0">

	把 24.0 替换为本地adt版本。



3. 打开终端，进入到Build目录下，执行：
		
		adt -package -storetype pkcs12 -keystore [您的p12证书名] -storepass [您的证书密码] -target ane com.talkingdata.game.ane extension.xml -swc LibAne_Game.swc -platform Android-ARM -C Android-ARM . -platform iPhone-ARM -C iPhone-ARM . -platform default -C default .
	
		//例如
		adt -package -storetype pkcs12 -keystore Certificates.p12 -storepass 111 -target ane com.talkingdata.game.ane extension.xml -swc LibAne_Game.swc -platform Android-ARM -C Android-ARM . -platform iPhone-ARM -C iPhone-ARM . -platform default -C default .



执行完成后，会在Build目录下生成名为 com.talkingdata.game.ane 的包，ane打包完成。