//
//  mainView.m
//  Ble SDK Demo
//
//  Created by yang sai on 2022/4/18.
//

#import "mainView.h"
#import "deviceTime.h"
#import "personalInfo.h"
#import "goal.h"
#import "otherDeviceInfo.h"
#import "autoMeasurement.h"
#import "realtimeStep.h"
#import "activityHistoryData.h"
#import "sleepHistoryData.h"
#import "heartRateHistoryData.h"
#import "temperatureHistoryData.h"
#import "spo2HistoryData.h"
#import "HRV_HistoryData.h"
#import "logFile.h"
#import "ppgView.h"
@interface mainView ()<MyBleDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    
    NSMutableArray * arrayPeripheral;
    NSMutableArray * arrayPeripheralStatus;
    
    
    NSArray * arrayButtonName;
    
    MBProgressHUD * HUD;
    
    BOOL isSkip;
}

@property (weak, nonatomic) IBOutlet UIButton *btnScan;


@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

@implementation mainView


-(void)viewWillAppear:(BOOL)animated
{
    [NewBle sharedManager].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_btnScan setTitle:LocalForkey(@"扫描") forState:UIControlStateNormal];
    
    arrayPeripheral = [[NSMutableArray alloc] init];
    arrayPeripheralStatus = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view from its nib.
    
    if (@available(iOS 11.0, *)) {
        _myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_myScrollView];
    _myScrollView.contentSize = CGSizeMake(Width,1000*Proportion);
    
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(20*Proportion, 100*Proportion, Width-40*Proportion, 300*Proportion) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource= self;
    myTableView.tableFooterView = [self MyFootView];
    [self.view addSubview:myTableView];
    [self HiddenTableView];
    
    
    arrayButtonName = [[NSArray alloc] initWithObjects:LocalForkey(@"设备时间"),LocalForkey(@"个人信息"),LocalForkey(@"目标"),LocalForkey(@"电池电量"),LocalForkey(@"设备版本"),LocalForkey(@"恢复出厂"),LocalForkey(@"MCU"),LocalForkey(@"自动测量"),LocalForkey(@"实时计步"),LocalForkey(@"总运动数据"),LocalForkey(@"详细运动数据"),LocalForkey(@"睡眠数据"),LocalForkey(@"心率数据"),LocalForkey(@"体温数据"),LocalForkey(@"血氧数据"),LocalForkey(@"HRV数据"),LocalForkey(@"PPG"),LocalForkey(@"Log日志"),nil];
    [self myMasonry];
    
}


-(void)myMasonry
{
    
    
    
    for (int i = 0; i < (arrayButtonName.count/2+(arrayButtonName.count%2)); i++) {
        
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion, 10*Proportion+i*60*Proportion, 140*Proportion, 50*Proportion)];
        
        btn.backgroundColor = UIColor.lightGrayColor;
        btn.layer.cornerRadius = 10 * Proportion;
        btn.titleLabel.textColor = UIColor.whiteColor;
        [btn setTitle:arrayButtonName[2*i] forState:UIControlStateNormal];
        btn.tag = 2*i;
        [_myScrollView addSubview:btn];
        [btn addTarget:self action:@selector(sdkEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if((2*i+1)<arrayButtonName.count){
            btn = [[UIButton alloc] initWithFrame:CGRectMake(Width-170*Proportion, 10*Proportion+i*60*Proportion, 140*Proportion, 50*Proportion)];
            btn.backgroundColor = UIColor.lightGrayColor;
            btn.layer.cornerRadius = 10 * Proportion;
            btn.titleLabel.textColor = UIColor.whiteColor;
            [btn setTitle:arrayButtonName[2*i+1] forState:UIControlStateNormal];
            btn.tag = 2*i+1;
            [_myScrollView addSubview:btn];
            [btn addTarget:self action:@selector(sdkEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    
    _btnScan.layer.cornerRadius  = 10 * Proportion;
    
    [_btnScan mas_makeConstraints:^(MASConstraintMaker * make)
     {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(40*Proportion);
        make.width.mas_equalTo(160*Proportion);
        make.height.mas_equalTo(50*Proportion);
    }];
    
    [_myScrollView mas_makeConstraints:^(MASConstraintMaker * make)
     {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(100*Proportion);
        make.width.mas_equalTo(Width);
        make.height.mas_equalTo(Height-100*Proportion);
    }];
}


-(UIView *)MyFootView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width-40*Proportion, 90*Proportion)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btnSkip = [[UIButton alloc]initWithFrame:CGRectMake(0, 5*Proportion, Width-40*Proportion, 35*Proportion)];
    btnSkip.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [btnSkip setTitle:LocalForkey(@"跳过并进入主界面") forState:UIControlStateNormal];
    [btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSkip.layer.cornerRadius = 5*Proportion;
    btnSkip.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSkip addTarget:self action:@selector(skipToDashboard) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSkip];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*Proportion, Width-40*Proportion, 35*Proportion)];
    button.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0];
    [button setTitle:LocalForkey(@"取消") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5*Proportion;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(HiddenTableView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

-(void)skipToDashboard
{
    isSkip = YES;
    [self HiddenTableView];
    [_btnScan setTitle:LocalForkey(@"断开连接 (跳过扫描)") forState:UIControlStateNormal];
}

-(void)ShowMyTableView
{
    
    [UIView animateWithDuration:0.7 animations:^{
        
        myTableView.hidden = NO;
        myTableView.alpha = 1;
        myTableView.transform = CGAffineTransformIdentity;
    }];
}

-(void)HiddenTableView
{
    [UIView animateWithDuration:0.7 animations:^{
        
        [[NewBle sharedManager] Stopscan];
        myTableView.alpha = 0;
        myTableView.transform = CGAffineTransformScale(self.view.transform, 0.01, 0.01);
        
        
    }];
}


#pragma mark MyBleDelegate
-(void)ConnectSuccessfully
{
    isSkip = NO;
    [_btnScan setTitle:LocalForkey(@"扫描") forState:UIControlStateNormal];
}
-(void)Disconnect:(NSError *_Nullable)error
{
    isSkip = NO;
    [_btnScan setTitle:LocalForkey(@"扫描") forState:UIControlStateNormal];
    [PishumToast showToastWithMessage:LocalForkey(@"设备断开连接") Length:TOAST_SHORT ParentView:self.view];
}
-(void)scanWithPeripheral:(CBPeripheral*_Nonnull)peripheral advertisementData:(NSDictionary<NSString *, id> *_Nonnull)advertisementData RSSI:(NSNumber *_Nonnull)RSSI
{
    int value = RSSI.intValue;
    if(value<0&&value>=-90){
        NSString * strName = peripheral.name;
        if(strName.length==0)
            return;;
        if([arrayPeripheral containsObject:peripheral])
        {
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:RSSI,@"RSSI",[NSNumber numberWithBool:NO],@"IsConnect", nil];
            NSUInteger index = [arrayPeripheral indexOfObject:peripheral];
            [arrayPeripheralStatus replaceObjectAtIndex:index withObject:dic];
        }
        else
        {
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:RSSI,@"RSSI",NO,@"IsConnect", nil];
            [arrayPeripheral addObject:peripheral];
            [arrayPeripheralStatus addObject:dic];
        }
        [myTableView reloadData];
    }
}
-(void)ConnectFailedWithError:(nullable NSError *)error
{
    
}
-(void)EnableCommunicate
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkResult) object:nil];
    HUD.label.text = LocalForkey(@"设备连接成功");
    [HUD hideAnimated:YES afterDelay:1];
    
}
-(void)BleCommunicateWithPeripheral:(CBPeripheral*)Peripheral data:(NSData *)data
{
    DeviceData * deviceData = [[DeviceData alloc] init];
    deviceData  = [[BleSDK sharedManager] DataParsingWithData:data];
    if (deviceData.dataType == FindMobilePhone)
    {
        [PishumToast showToastWithMessage:LocalForkey(@"正在查找手机") Length:TOAST_SHORT ParentView:self.view];
    }
    else if (deviceData.dataType == SOS)
    {
        [PishumToast showToastWithMessage:LocalForkey(@"正在发送SOS") Length:TOAST_SHORT ParentView:self.view];
    }
    else if (deviceData.dataType == openRRInterval)
    {
        NSLog(@"openRRInterval");
        
    }
    else if (deviceData.dataType == closeRRInterval)
    {
        NSLog(@"closeRRInterval");
    }
    else if (deviceData.dataType == realtimeRRIntervalData)
    {
        NSDictionary * dicData  = deviceData.dicData;
        NSLog(@"RRIntervalData = %@",dicData[@"RRIntervalData"]);
    }
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString * str = ((CBPeripheral*)[arrayPeripheral objectAtIndex:indexPath.row]).name;
    if(str.length==0)
        str = @"style";
    NSDictionary * dic = [arrayPeripheralStatus objectAtIndex:indexPath.row];
    if(((NSNumber*)dic[@"IsConnect"]).boolValue==NO)
        [cell.textLabel setText:[str stringByAppendingString:[NSString stringWithFormat:@"    📶%@",dic[@"RSSI"]]]];
    else
        [cell.textLabel setText:[str stringByAppendingString:[NSString stringWithFormat:@"    📶%@",@"ConnectBySystem"]]];
    cell.textLabel.font = [UIFont fontWithName:@"Courier" size:14];;
    return cell;
    
    
} // 创建单元格



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  arrayPeripheral.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:12];
    HUD.label.text = LocalForkey(@"正在连接设备...");
    [self performSelector:@selector(checkResult) withObject:nil afterDelay:10];
    
    [[NewBle sharedManager] Stopscan];
    [self HiddenTableView];
    [[NewBle sharedManager] connectDevice:[arrayPeripheral objectAtIndex:indexPath.row]];
}


-(void)checkResult
{
    if([[NewBle sharedManager] isConnectOrConnecting]== NO)
    {
        HUD.label.text = LocalForkey(@"设备连接失败,请重试!");
        [HUD hideAnimated:YES afterDelay:1];
    }
}


-(void)sdkEvent:(UIButton*)button
{
    if(button.tag==0)
    {
        deviceTime *  deviceTimeView = [[deviceTime alloc] init];
        [self.navigationController pushViewController:deviceTimeView animated:YES];
    }
    else if(button.tag==1)
    {
        personalInfo *  personalInfoView = [[personalInfo alloc] init];
        [self.navigationController pushViewController:personalInfoView animated:YES];
    }

    else if (button.tag==2)
    {
        goal *  goalView = [[goal alloc] init];
        [self.navigationController pushViewController:goalView animated:YES];
    }
    else if (button.tag>=3&&button.tag<=6)
    {
        otherDeviceInfo *  otherDeviceInfoView = [[otherDeviceInfo alloc] init];
        [self.navigationController pushViewController:otherDeviceInfoView animated:YES];
    }
   
    else if (button.tag==7)
    {
        autoMeasurement * autoMeasurementView = [[autoMeasurement alloc] init];
        [self.navigationController pushViewController:autoMeasurementView animated:YES];
    }

    else if (button.tag==8)
    {
        realtimeStep * realtimeStepView = [[realtimeStep alloc] init];
        [self.navigationController pushViewController:realtimeStepView animated:YES];
    }
    else if (button.tag==9||button.tag==10)
    {
        activityHistoryData * activityHistoryDataView = [[activityHistoryData alloc] init];
        [self.navigationController pushViewController:activityHistoryDataView animated:YES];
    }
    else if (button.tag==11)
    {
        sleepHistoryData * sleepHistoryDataView = [[sleepHistoryData alloc] init];
        [self.navigationController pushViewController:sleepHistoryDataView animated:YES];
    }
    else if (button.tag==12)
    {
        heartRateHistoryData * heartRateHistoryDataView = [[heartRateHistoryData alloc] init];
        [self.navigationController pushViewController:heartRateHistoryDataView animated:YES];
    }
    else if (button.tag==13)
    {
        temperatureHistoryData * temperatureHistoryDataView = [[temperatureHistoryData alloc] init];
        [self.navigationController pushViewController:temperatureHistoryDataView animated:YES];
    }
    else if (button.tag==14)
    {
        spo2HistoryData * spo2HistoryDataView = [[spo2HistoryData alloc] init];
        [self.navigationController pushViewController:spo2HistoryDataView animated:YES];
    }
    else if (button.tag==15)
    {
        HRV_HistoryData * HRV_HistoryDataView = [[HRV_HistoryData alloc] init];
        [self.navigationController pushViewController:HRV_HistoryDataView animated:YES];
    }
 
    else if (button.tag==16)
    {
        
        ppgView * myPPGView= [[ppgView alloc] init];
        [self.navigationController pushViewController:myPPGView animated:YES];
    }
    else if (button.tag==17)
    {
        
        logFile * logFileView = [[logFile alloc] init];
        [self.navigationController pushViewController:logFileView animated:YES];
    }
}


- (IBAction)scanDevice:(UIButton *)sender {
    
    if([NewBle sharedManager].activityPeripheral.state==2)
    {
        [[NewBle sharedManager] Disconnect];
        [self performSelector:@selector(findMyBle) withObject:nil afterDelay:1];
    }
    else
    {
        [self findMyBle];
    }
}


-(void)findMyBle
{
    isSkip = NO;
    [_btnScan setTitle:LocalForkey(@"扫描") forState:UIControlStateNormal];
    [arrayPeripheral removeAllObjects];
    [arrayPeripheralStatus removeAllObjects];
    [myTableView reloadData];
    //检查是否有蓝牙被系统蓝牙连上
    NSArray * bleArray = [[NewBle sharedManager]  retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0xfff0"]]];
    if(bleArray.count>0)
    {
        //        [[MyBle sharedManager] connectPeripheral:bleArray.lastObject];
        for (int i = 0; i<[bleArray count]; i++) {
            CBPeripheral * ble = [bleArray objectAtIndex:i];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"RSSI",[NSNumber numberWithBool:YES],@"IsConnect", nil];
            [arrayPeripheral addObject:ble];
            [arrayPeripheralStatus addObject:dic];
        }
        
    }
    
    
    [self ShowMyTableView];
    [[NewBle sharedManager] startScanningWithServices:nil];
}



@end
