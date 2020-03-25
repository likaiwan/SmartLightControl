//
//  BluetoothEquipment.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/24.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

//外围设备名称
#define PERIPHERAL_NAME     @"KL888888"

//服务的UUID
#define kServiceUUID        @"C4FB2349-72FE-4CA2-94D6-1F3CB16331EE"

//特征的UUID
#define kCharacteristicUUID @"6A3E4B28-522D-4B3B-82A9-D5E2004534FC"


@interface BluetoothEquipment : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

//中心设备管理器
@property(nonatomic,strong)CBCentralManager *centralManager;

//外围设备管理器
@property(nonatomic,strong)CBPeripheralManager *peripheralManager;

//
@property(nonatomic,strong)CBPeripheral *myPeripheral;

//连接上的设备
@property(nonatomic,strong)NSMutableArray *connectPeripherals;

// 上锁和解锁的Characteristic
@property(nonatomic,strong)CBCharacteristic *lockUnlockCharacteristic;

// 电量的Characteristic
@property(nonatomic,strong)CBCharacteristic *readPowerCharacteristic;


// 初始化中心设备管理器
-(void)initCentralManager;

// 传入上锁指令
-(void)setLockInstruction:(NSString *)lockInstruction;

// 传入解锁指令
-(void)setUnlockInstruction:(NSString *)unlockInstruction;

//单例实现方法
//+ (BluetoothEquipment *)share;

@end

NS_ASSUME_NONNULL_END
