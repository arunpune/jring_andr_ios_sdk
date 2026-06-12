99dateOfLastData "yyyy-MM-dd HH:mm:ss or yyyy.MM.dd HH:mm:ss"

J-Style 2301 smart healthcare ring Android&IOS SDK - 20230630

sdk使用说明（operation instructions）：
数据解析流程：Bluetooth 4.0 + byte [] data receiving - > Data Processing - > data return

蓝牙4.0+的 byte[]数据接收->数据处理->数据返回

蓝牙系统onCharacteristicChanged（）方法中接收数据->广播发送数据到BaseActivity->SDK处理数据->dataCallback()返回数据

Receive data in oncharacteristicchanged() method of Bluetooth system - > broadcast and send data to baseactivity - > SDK process data - > datacallback() return data

1：Receive data in oncharacteristicchanged() method of Bluetooth system



2：broadcast and send data to baseactivity



3：SDK process data - > datacallback() return data

Activity implements DataListener{}



详细接口信息（Detailed interface information）

0： 设置时间（BLE Data Format）

Bluetooth instruction head	0x01
Usage method	BleSDK.SetDeviceTime(MyDeviceTime )
Parameter	Calendar calendar=Calendar.getInstance();int year=calendar.get(Calendar.YEAR);int month=calendar.get(Calendar.MONTH)+1;int day=calendar.get(Calendar.DAY_OF_MONTH);int hour=calendar.get(Calendar.HOUR_OF_DAY);int min=calendar.get(Calendar.MINUTE);int second=calendar.get(Calendar.SECOND);MyDeviceTime setTime=new MyDeviceTime();setTime.setYear(year);setTime.setMonth(month);setTime.setDay(day);setTime.setHour(hour);setTime.setMinute(min);setTime.setSecond(second);sendValue(BleSDK.SetDeviceTime(setTime));
Data returned	{dataType=0, //Current 1th directivedicData={},dataEnd=true //End of data ( true or false)}
1： 获取时间（Get device time）

Bluetooth instruction head	0x41
Usage method	BleSDK.GetDeviceTime()
Data returned	{dataEnd=true,dataType=1, dicData={strDeviceTime=20-04-26 14:41:49,GPSTime=00.00.00}}
2： 设置用户个人信息（Set user profile）

Bluetooth instruction head	0x02
Usage method	BleSDK.SetPersonalInfo(MyPersonalInfo)
Parameter	MyPersonalInfo setPersonalInfo=new MyPersonalInfo();setPersonalInfo.setAge(age);//1-220setPersonalInfo.setHeight(height);setPersonalInfo.setWeight(weight);setPersonalInfo.setStepLength(stepLength);//step lengthsetPersonalInfo.setSex(gender); //Male 1, female 0sendValue(BleSDK.SetPersonalInfo(setPersonalInfo));
Data returned	{dataType=2, dicData={}, dataEnd=true}
3： 获取用户个人信息（Get user's personal information）

Bluetooth instruction head	0x42
Usage method	BleSDK.GetPersonalInfo()
parameter	
Data returned	{dataEnd=true, dataType=3, dicData={MyStride=13,//step lengthMyAge=30,MyWeight=120,MyGender=0,MyHeight=38}}
6： 设置设备的mac地址（Set the MAC address of the device）

Bluetooth instruction head	0x05
Usage method	BleSDK.SetDeviceName(name)name aabbccddffee
Data returned	{DataType=6,Data=,dataEnd=true}
9： 读取设备电量（Read device power）

Bluetooth instruction head	0x13
Usage method	BleSDK.GetDeviceBatteryLevel()
Data returned	{dataType=9, dicData={batteryLevel=10}, dataEnd=true}
10： 读取MAC地址（Read MAC address）

Bluetooth instruction head	0x22
Usage method	BleSDK.GetDeviceMacAddress()
Data returned	{dataEnd=true, dataType=10, dicData={macAddress=FE:53:8C:0D:73:FB}}
11： 读取软件版本号（Read software version number）

Bluetooth instruction head	0x27
Usage method	BleSDK.GetDeviceVersion()
Data returned	{dataType=11, dicData={deviceVersion=0.3.2.1}, dataEnd=true}
12： 恢复出厂设置（Restore factory settings）

Bluetooth instruction head	0x12
Usage method	BleSDK.Reset()
Data returned	{dataType=12, dataEnd=true}
13： MCU软复位指令（MCU soft reset command）

Bluetooth instruction head	0x2E
Usage method	BleSDK.MCUReset()
Data returned	{dataType=13, dataEnd=true}
16： 读取自动检测时段（Read auto detect heart rate period）

Bluetooth instruction head	0x2B
Usage method	BleSDK.GetAutomatic(AutoMode type)
Data returned	{dataType=17, dicData={heartStartMinter=00,workModel=2, //0 ,1, 2 One of the three modelsheartEndHour=23,heartEndMinter=59,heartStartHour=00,workTime=5,//Indicates how many minutes to promptweekValue=1-1-1-1-1-1-1},//Bit1 = 0 means Monday is not enabled, Bit1 = 1 means Monday is enabled.Bit2 = 0 means Tuesday is not enabled, bit2 = 1 means Tuesday is enabled.Bit3 = 0 means Wednesday is not enabled, bit3 = 1 means Wednesday is enabled.Bit4 = 0 means Thursday is not enabled, bit4 = 1 means Thursday is enabled.Bit5 = 0 means Friday is not enabled, bit5 = 1 means Friday is enabled.Bit6 = 0 means Saturday is not enabled, bit6 = 1 means Saturday is enabled.Bit7 = 0 means Sunday is not enabled, bit7 = 1 means Sunday is enabled.dataEnd=true}
17： 设置自动检测时段（Set automatic heart rate detection period）

Bluetooth instruction head	0x2A
Usage method	sendValue(BleSDK.SetAutomaticHRMonitoring(MyAutomaticHRMonitoring ,autoMode));AutoMode :AutoHeartRate, AutoSpo2,AutoTemp,AutoHrv
Data returned	{dataType=17, dicData={}, dataEnd=true}
public class MyAutomaticHRMonitoring extends SendData{ int open;//1 开启整个时间段都测量 2时间段内间隔测量 0关闭 // 1. Enable measurement throughout the entire time period 2. Measure intervals within the time period 0. Close int startHour;//开始小时 Starting hours int startMinute;//开始分钟 Start minute int endHour;//结束小时 End Hour int endMinute;//结束分钟 End minute int week;//星期一到星期日 开启选择 Monday to Sunday open selection int time;//多少时间测试一次，单位是分钟。 How many times does it take to test, in minutes.
23：开始实时计步（Start real time step ）

Bluetooth instruction head	0x09
Usage method	BleSDK.RealTimeStep(boolean enable,boolean tempEnable )
Parameter	enable //True turns counting on, false turns counting offtempEnable //True opening temperature, false closing temperature
Data returned	{dataType=19, dicData={heartRate=89,//Heart ratedistance=0.12, //distancestep=193, //Step numberExerciseTime=0,calories=11.3,exerciseMinutes=1,}, dataEnd=true}
24： 获得计步总数据(Get step total data）

Bluetooth instruction head	0x51
Usage method	GetTotalActivityDataWithMode(Mode,String dateOfLastData)Mode 0: table ⽰ is read from the latest location (up to 50 groups of data) 2: table ⽰ then read (when the total data is ⼤ 50) 0x99: table ⽰ delete all the motion data
Data returned	{dataEnd=false, dataType=24, dicData=[{date=20.04.18, goal=0, distance=0.00, step=0, ExerciseTime=0, calories=0.00, exerciseMinutes=0}, {date=20.04.17, goal=26, distance=1.61, step=2647, ExerciseTime=19, calories=79.64, exerciseMinutes=1339}, {date=20.04.16, goal=0, distance=0.00, step=0, ExerciseTime=0, calories=0.00, exerciseMinutes=0}, {date=20.04.15, goal=46, distance=3.70, step=4689, ExerciseTime=23, calories=244.83, exerciseMinutes=1712}]}{dataEnd=true, dataType=24, dicData=[]}
25： 获得步数详细数据（Get step details）

Bluetooth instruction head	0x52
Usage method	GetDetailSleepDataWithMode(byte modeString dateOfLastData)*0x99: delete step details,*0: read the latest step details.*1: read the step details of the specified location.*2: continue the next segment of data at the last read location
Data returned	{dataEnd=true, dataType=25, dicData=[{date=20.04.15 17:00:53, detailMinterStep=102, distance=0.05, calories=2.77, arraySteps=16 0 18 10 36 0 0 22 0 0}, {date=20.04.15 15:48:24, detailMinterStep=1175, distance=1.08, calories=75.99, arraySteps=196 192 194 193 195 183 22 0 0 0}, {date=20.04.15 15:38:19, detailMinterStep=1931, distance=1.77, calories=124.93, arraySteps=183 196 195 196 192 196 194 194 192 193}]}
26： 获得睡眠详细数据（Get sleep details）

Bluetooth instruction head	0x53
Usage method	GetDetailSleepDataWithMode(byte modeString dateOfLastData)*0x99: delete step details,*0: read the latest step details.*1: read the step details of the specified location.*2: continue the next segment of data at the last read locationdateOfLastData: yyyy-MM-dd HH:mm:ss or yyyy.MM.dd HH:mm:ss
Data returned	{dataEnd=false, dataType=26, dicData=[{date=2021-10-21 14:00:02,sleepUnitLength=1, //1 for 1 minute sleep, 5 for 5 minutes sleeparraySleepQuality=39 2 2 2 2 2 2 2 2 2 2 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 }]}{DataType=26, Data=[], DataEnd=true}DataEnd=true数据已经同步完成
27： 获得心率数据（Get heart rate data）

Bluetooth instruction head	0x54
Usage method	GetDynamicHRWithMode(byte Number,String dateOfLastData)Number0x99: delete all heart rate data,0: read the latest heart rate data.1: Read the heart rate data at the specified location.2: Continue the next segment of data at the last read location.
Data returned	{dataEnd=false, dataType=27, dicData=[{date=20.04.15 19:19:59, arrayDynamicHR=84 89 94 86 86 87 89 87 86 87 90 83 81 81 80}, {date=20.04.15 18:27:59, arrayDynamicHR=75 77 0 0 0 0 0 0 0 0 0 0 0 0 0}, {date=20.04.15 17:15:59, arrayDynamicHR=78 75 79 0 0 0 0 0 0 0 0 0 0 0 0}, {date=20.04.15 16:52:59, arrayDynamicHR=79 80 85 85 81 90 83 77 79 80 74 72 75 76 81}, {date=20.04.15 16:09:59, arrayDynamicHR=70 72 0 0 0 0 0 0 0 0 0 0 0 0 0}]}{dataEnd=true, dataType=27, dicData=[]}
28： 获得单次心率数据（间隔测试心率）（Obtain single heart rate data (interval test heart rate)

Bluetooth instruction head	0x55
Usage method	GetStaticHRWithMode(byte mode,String dateOfLastData))mode0x99: delete all single heart rate data,0: read the latest single heart rate data.1: Read the single heart rate data at the specified location.2: Continue the next segment of data at the last read location
Data returned	{dataEnd=false, dataType=28, dicData=[{date=20.04.15 17:20:30, onceHeartValue=108}, {date=20.04.15 17:00:30, onceHeartValue=78}, {date=20.04.15 16:55:30, onceHeartValue=71}, {date=20.04.15 16:50:30, onceHeartValue=80}, {date=20.04.15 16:45:30, onceHeartValue=77}, {date=20.04.15 16:40:30, onceHeartValue=59}, {date=20.04.15 16:30:30, onceHeartValue=70}, {date=20.04.15 16:25:30, onceHeartValue=70}, {date=20.04.15 16:20:30, onceHeartValue=83}, {date=20.04.15 16:15:30, onceHeartValue=64}, {date=20.04.15 16:10:30, onceHeartValue=92}, {date=20.04.15 16:00:30, onceHeartValue=71}]}{dataEnd=true, dataType=29, dicData=[]}
37： 获得/删除HRV测试数据（Set/Get HRV test data）

Bluetooth instruction head	0x56
Usage method	GetHRVDataWithMode(int mode)0x99: delete all motion data,1: Read the movement data of the specified position.2: Continue the next segment of data at the last read location
Data returned	{DataType=37, Data=[{hrvBloodValue=0, historyDate=20.04.10 09:10:30, heartValue=0, HighPressure=0, hrvValue=63, KHrvBreathRate=89, LowPressure=0, KHrvMoodValue=86, hrvTired=53}, {hrvBloodValue=55, historyDate=10.09.05 30:41:00, heartValue=0, HighPressure=86, hrvValue=0, KHrvBreathRate=32, LowPressure=90, KHrvMoodValue=0, hrvTired=0}, {hrvBloodValue=0, historyDate=00.30.6c 00:00:3a, heartValue=86, HighPressure=0, hrvValue=0, KHrvBreathRate=16, LowPressure=32, KHrvMoodValue=4, hrvTired=91}, {hrvBloodValue=92, historyDate=33.00.00 43:00:00, heartValue=0, HighPressure=4, hrvValue=86, KHrvBreathRate=80, LowPressure=16, KHrvMoodValue=8, hrvTired=32}, {hrvBloodValue=32, historyDate=00.3f.00 00:56:5d, heartValue=4, HighPressure=8, hrvValue=0, KHrvBreathRate=138, LowPressure=69, KHrvMoodValue=48, hrvTired=16}, {hrvBloodValue=16, historyDate=00.00.56 5e:00:20, heartValue=8, HighPressure=48, hrvValue=4, KHrvBreathRate=0, LowPressure=65, KHrvMoodValue=0, hrvTired=64}, {hrvBloodValue=9, historyDate=56.5f.00 20:03:28, heartValue=89, HighPressure=0, hrvValue=8, KHrvBreathRate=0, LowPressure=0, KHrvMoodValue=69, hrvTired=66}], DataEnd=false}{DataType=37, Data=[{hrvBloodValue=0, historyDate=20.03.23 19:49:59, heartValue=0, HighPressure=0, hrvValue=83, KHrvBreathRate=97, LowPressure=0, KHrvMoodValue=86, hrvTired=69}, {hrvBloodValue=69, historyDate=20.14.59 59:53:00, heartValue=0, HighPressure=86, hrvValue=0, KHrvBreathRate=32, LowPressure=98, KHrvMoodValue=0, hrvTired=0}], DataEnd=true}
deletehrv	{dataEnd=true, dataType=72, dicData=[]}
59：自动测试温度数据（Automatic test temperature data）

Bluetooth instruction head	0x62
Usage method	sendValue(BleSDK.GetTemperature_historyDataWithMode(mode,String dateOfLastData)));Mode：0x99: delete all temperature data,1: Read the temperature data of the specified position.2: Continue to read the last location of the next piece of data
Data returned	
60：健康测量控制（Health measurement control）

Bluetooth instruction head	0x28
Usage method	SetDeviceMeasurementWithType(AutoTestMode dataType,long second, boolean open)AutoTestMode ：AutoHeartRate/ AutoSpo2Second：最少30秒 30 seconds minimum
Data returned	AutoHeartRate:{dataEnd=true, dataType=74, dicData={stress=0, Type=2, lowPressure=0, heartRate=0, Bloodoxygen=0, hrv=0, highPressure=0}}_AutoSpo2{dataEnd=true, dataType=75, dicData={stress=0, Type=3, lowPressure=0, heartRate=0, Blood_oxygen=0, hrv=0, highPressure=0}}
：

连接设备状态监听 Connected device status monitoring

BleManager.getInstance().connectDevice(address, true, new BleConnectionListener() {
@Override
public void BleStatus(int status, int newState) {//蓝牙4.0连接状态 Bluetooth 4.0 connection status
Log.e(TAG, "BleStatus: "+status+"***"+newState);
}
@Override
public void ConnectionSucceeded() {//连接设备成功 Successfully connected the device
Log.e(TAG, "ConnectionSucceeded");
}
@Override
public void Connecting() {//设备连接中 Device is connected
Log.e(TAG, "Connecting");
}
@Override
public void ConnectionFailed() {//设备连接失败 Device connection failed
Log.e(TAG, "ConnectionFailed");
}
@Override
public void OnReconnect() {//重新连接中 Reconnecting
Log.e(TAG, "OnReconnect");
}
@Override
public void BluetoothSwitchIsTurnedOff() {//蓝牙开关被关闭 Bluetooth switch is turned off
Log.e(TAG, "BluetoothSwitchIsTurnedOff");
}
});

手机蓝牙开关状态获取Mobile Bluetooth switch status acquisition

protected class ListenerReceiver extends BroadcastReceiver {
@Override
public void onReceive(Context context, Intent intent) {
if (Objects.requireNonNull(intent.getAction()).equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
switch (state) {
case BluetoothAdapter.STATE_ON://Bluetooth on
if (TextUtils.isEmpty(address)) {
Log.i(TAG, "onCreate: address null ");
return;
}
BleManager.getInstance().connectDevice(address,true,null);
break;
case BluetoothAdapter.STATE_OFF://Bluetooth off
if(null!=mainAdapter){
mainAdapter.setEnable(false);
}
if(null!=btConnect){
btConnect.setEnabled(true);}
BleManager.getInstance().disconnectDevice();
break;
}
}
}
}