# TalkingData Game Analytics SDK for Flash Air

### 项目简介：

- LibAne_Game	：Flex Library项目。

- LibBuild_Game	：用于编译ane的主要目录。

- LibIOS_Game：用于生成iOS静态库的Xcode工程。

- LibJava_Game：用于生成jar文件的Flash Builder/Eclipse工程。


## 生成ANE

### 准备工作

**Android:**

1. 导入LibJava_Game到Flash Builder中。为此项目添加外部依赖包：

	![](http://i2.muimg.com/579600/dace98a1e84b3d6f.png)

 	- FlashRuntimeExtensions.jar：
 
		在Air SDK目录下，如 C:\Program Files\Adobe\Adobe Flash Builder 4.7 (64 Bit)\sdks\21.0\lib\android\FlashRuntimeExtensions.jar。

 	- TalkingData_Game_Analytics_SDK.jar：
 
		在LibBuild_Game中。

 	- android.jar：

		在Android SDK的platforms目录下，如C:\Program Files\Android\sdk\platforms\android-25\android.jar。

2. 添加依赖后，Clean Project。

3. 然后右键点击项目，导出Jar文件,并重命名为 libjava_game.jar。

4. 把导出的libjava_game.jar放到LibBuild_Game文件夹下，同时把从TalkingData官网下载的Game_Analytics_SDK_Android_V3.x.xx.jar也放到LibBuild_Game文件夹下。
 
5. 使用jar命令合并Game_Analytics_SDK_Android_V3.x.xx.jar和刚刚导出的jar包：

		mkdir tmp
		cd tmp
		jar -xvf 　../libjava_game.jar
		jar -xvf 　../Game_Analytics_SDK_Android_V3.x.xx.jar
		jar -cvf  LibGame.jar .

确保合并后的jar包名为LibGame.jar，如不是，请重命名为LibGame.jar。把LibGame.jar放在LibBuild_Game目录下的Android-ARM文件夹下。

**iOS:**

1. 导入LibIOS_Game目录下的工程到Xcode中。

2. 导入TalkingDataGA.h和libTalkingDataGA.a两个文件到Xcode工程中，文件在LibBuild_Game中。

3. 确保您的Build Configuration为Release状态。
	![](http://i2.muimg.com/579600/59305650afa9697e.png)

4. 先选择设备类型为iPhone ，执行 command + B，会在Products目录下生成对应的libLibIOS_Game.a包；再选择设备类型为iPhoneSimulator，执行 command + B，也会在Products目录下生成对应的libLibIOS_Game.a包。如下图：

	![](http://i2.muimg.com/579600/0cc14c9424cb64a2.png)

5. 使用命令将两个静态库合并：

		lipo -create [iPhone类型的静态库路径] [iPhoneSimulator类型的静态库路径] -output [输出路径]
		
		//例如
		lipo -create /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphoneos/libLibIOS_Game.a /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/Release-iphonesimulator/libLibIOS_Game.a  -output /Users/xxx/Library/Developer/Xcode/DerivedData/LibIOS_Game-gdjpcsnnhaozckbbqfwdzxmywylq/Build/Products/libLibIOS_Game.a

把合成后的libLibIOS_Game.a静态库重命名为 libGameAnalytics.a ，并放到LibBuild_Game目录下的iPhone-ARM文件夹下。


### 打包ane

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

## 集成ANE

详细集成文档请查阅文档 TalkingData GameAnalytics Adobe AIR ANE 接入指南 3.1.x.pdf 。