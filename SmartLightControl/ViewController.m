//
//  ViewController.m
//  SmartLightControl
//
//  Created by 李凯 on 2019/11/20.
//  Copyright © 2019 李凯. All rights reserved.
//

#import "ViewController.h"
#import "LKVColorPicker.h"
#import "GosDeviceControl.h"
#import "LKVColorPicker.h"
#import "RGBColorPicker.h"
#import "config.h"

#import "BluetoothEquipment.h"

@interface ViewController ()<LKVColorPickerDelegate,GosDeviceControlDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeLight;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlide;

//色环-色彩环
@property (weak, nonatomic) IBOutlet LKVColorPicker *hueColorPicker;
//色环-色温环
@property (weak, nonatomic) IBOutlet RGBColorPicker *rgbColorPicker;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *smallCircleColorView;
@property (weak, nonatomic) IBOutlet UIView *countDownView;

// 约束值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewWidthCon;

// 读写控制器
@property (nonatomic, strong) GosDeviceControl *deviceControlTool;

// 线程
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) NSString *deviceName;


@property (nonatomic, strong) BluetoothEquipment *BLE;

@end

@implementation ViewController

//函数功能:视图控制器中的视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigaionBar];
    [self setupUI];
    [self drawCircle];
    
    self.deviceControlTool = [GosDeviceControl sharedInstance];
    self.deviceControlTool.delegate = self;
    
    self.hueColorPicker.delegate = self;
    self.rgbColorPicker.delegate = self;
    
    
    self.titleLabel.text = [self deviceName];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self                  //监听器
                                             selector:@selector(updateUI)   //接收到通知后的处理函数
                                                 name:GosDeviceControlDataValueUpdateNotification   //消息名称
                                               object:nil];                 //接收通知的对象
    
    self.BLE = [[BluetoothEquipment alloc] init];
    
}

// 函数功能:出现内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 函数功能:视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self updateUI];
    
    [[self BLE]initCentralManager];
    
}

//函数功能:视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//函数功能:视图被销毁
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 画圆
- (void)drawCircle
{
    self.smallCircleColorView.layer.cornerRadius = self.colorViewWidthCon.constant / 2;
}

#pragma mark -
- (void)setupUI
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if(screenWidth == 320 && screenHeight == 480){
        self.colorViewWidthCon.constant = 27;
    }
    else{
        self.colorViewWidthCon.constant = (33.0 / 568) *screenHeight;
    }
}

#pragma mark -
- (void)setUpNavigaionBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"标题"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
}

- (void)goBack
{
    
}


- (void)updateUI{
    
    //更新模式按钮 切换色环
    GosDeviceModeType modeType = self.deviceControlTool.mode;
    
    self.modeBtn.selected = modeType;
    self.rgbColorPicker.hidden = !modeType;
    self.hueColorPicker.hidden = modeType;
    
    if(modeType == GosDeviceModeColor){
        //色彩模式
        CGFloat red = self.deviceControlTool.colorRed / 255.0;
        CGFloat green = self.deviceControlTool.colorGreen / 255.0;
        CGFloat blue = self.deviceControlTool.colorBlue / 255.0;
        self.hueColorPicker.color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        self.smallCircleColorView.backgroundColor = self.hueColorPicker.color;
    }else{
        //色温模式
        CGFloat red = self.deviceControlTool.temperatureRed / 255.0;
        CGFloat green = self.deviceControlTool.temperatureGreen / 255.0;
        CGFloat blue = self.deviceControlTool.temperatureBlue / 255.0;
        self.rgbColorPicker.color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        self.smallCircleColorView.backgroundColor = self.rgbColorPicker.color;
    }
    self.brightnessSlide.value = self.deviceControlTool.brightness;
    
    if(self.deviceControlTool.powerSwitch == YES){
        //开灯
        self.coverView.hidden = YES;
        self.closeLight.hidden = NO;
        self.goBackBtn.hidden = NO;
        self.menuBtn.hidden = NO;
        self.countDownView.hidden = !self.deviceControlTool.countDownSwitch;
        self.countDownLabel.text = [NSString stringWithFormat:@"%zd%@",self.deviceControlTool.countDownOffMin,NSLocalizedString(@"minutes later", nil)];
    }else{
        //关灯
        self.coverView.hidden = NO;
        self.closeLight.hidden = NO;
        self.goBackBtn.hidden = YES;
        self.menuBtn.hidden = YES;
        self.countDownView.hidden = YES;
    }
}


#pragma mark - 窗体事件

// 导航栏-返回按钮
- (IBAction)goBackDeviceList:(UIButton *)sender {
    
}

// 导航栏-下拉菜单按钮
- (IBAction)menuBtnDidClick:(UIButton *)sender {
    
}

//  模式按钮被点击-切换模式
- (IBAction)modeBtnDidClcik:(UIButton *)sender {
    
    self.modeBtn.selected = !self.modeBtn.selected;
    BOOL typeMode = self.modeBtn.selected;
    
    self.rgbColorPicker.hidden = !typeMode;
    self.hueColorPicker.hidden = typeMode;
    
    self.deviceControlTool.mode = typeMode;
    [self.deviceControlTool writeDataPoint:GosDeviceWriteMode value:@(typeMode)];
    [self updateUI];
}

// 滑动条
- (IBAction)slideStopDrag:(UISlider *)sender {
    
    self.deviceControlTool.brightness = sender.value;
    [self.deviceControlTool writeDataPoint:GosDeviceWriteBrightness value:@(sender.value)];
    [self updateUI];
}

// 关灯
- (IBAction)closeLightBtnDidClick:(UIButton *)sender {
    
    self.coverView.hidden = NO;
    self.closeLight.hidden = YES;
    self.goBackBtn.hidden = YES;
    self.menuBtn.hidden = YES;
    
    self.deviceControlTool.powerSwitch = NO;
    [self.deviceControlTool writeDataPoint:GosDeviceWritePowerSwitch value:@(NO)];
    [self updateUI];
}


- (IBAction)turnOnLight:(UIButton *)sender {
    
    self.coverView.hidden = YES;
    self.closeLight.hidden = NO;
    self.goBackBtn.hidden = NO;
    self.menuBtn.hidden = NO;
    
    self.deviceControlTool.powerSwitch = YES;
    [self.deviceControlTool writeDataPoint:GosDeviceWritePowerSwitch value:@(YES)];
    [self updateUI];
}



#pragma mark - LKVColorPickerDelegate

- (void)colorPicker:(LKVColorPicker *)colorPicker changedColor:(UIColor *)color
{
    CGFloat colorRed;
    CGFloat colorGreen;
    CGFloat colorBlue;
    [color getColorWithRed:&colorRed withGreen:&colorGreen withBlue:&colorBlue];

    if (self.deviceControlTool.mode == GosDeviceModeColor)
    {
        self.deviceControlTool.colorRed = colorRed;
        self.deviceControlTool.colorBlue = colorBlue;
        self.deviceControlTool.colorGreen = colorGreen;
    }
    else
    {
        self.deviceControlTool.temperatureRed = colorRed;
        self.deviceControlTool.temperatureBlue = colorBlue;
        self.deviceControlTool.temperatureGreen = colorGreen;
    }

    [self.deviceControlTool writeColor:colorRed colorG:colorGreen colorB:colorBlue];
    self.smallCircleColorView.backgroundColor = color;
    
    NSLog(@"色彩值:R[%.2f] B[%.2f] G[%.2f]",colorRed,colorBlue,colorGreen);
}

//当设备不可控时会调用
- (void)GosDeviceControl:(GosDeviceControl *)deviceControl deviceUncontrol:(NSString *)device
{
    
    //NSLog(@"当设备不可用时调用：%@",device);
}


- (NSOperationQueue *)queue
{
    if(_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSString *)deviceName
{
    NSString *tempName = nil;
    
    tempName = @"设备名称";
    
    if(tempName.length > 10)
    {
        tempName = [tempName substringWithRange:NSMakeRange(0, 10)];
        tempName = [NSString stringWithFormat:@"%@...",tempName];
    }
    return tempName;
}

@end
