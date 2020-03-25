//
//  BluetoothEquipment.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/24.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "BluetoothEquipment.h"

@implementation BluetoothEquipment

//传入上锁指令
- (void)setLockInstruction:(NSString *)lockInstruction{
    if (_lockUnlockCharacteristic) {
        NSData* lockValue = [self dataWithString:lockInstruction];
        NSLog(@"上锁的指令lockValue= %@",lockValue);
        [_myPeripheral writeValue:lockValue forCharacteristic:_lockUnlockCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

//传入解锁指令
-(void)setUnlockInstruction:(NSString *)unlockInstruction{
    if (_lockUnlockCharacteristic) {
        NSData* unlockValue = [self dataWithString:unlockInstruction];
        NSLog(@"解锁的指令unlockValue= %@",unlockValue);
        [_myPeripheral writeValue:unlockValue forCharacteristic:_lockUnlockCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}
 
//初始化中心设备管理器
- (void)initCentralManager{
    //实例化
    if(_centralManager == nil){
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    
    //self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

#pragma mark - CBCentralManager代理方法
//创建完成CBCentralManager对象之后会回调的代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"系统蓝牙关闭了，请先打开蓝牙");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"系统蓝未被授权");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"系统蓝牙当前状态不明确");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"系统蓝牙设备不支持");
            break;
        case CBCentralManagerStatePoweredOn:
            //扫描外设：如果你将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
            //NSMutableDictionary *options = [NSMutableDictionary dictionary]
            
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            
//            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]]
//                                            options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            
            //开始扫描外围设备
            //[central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
        default:
            NSLog(@"此设备不支持蓝牙或未打开蓝牙功能，无法作为外围设备。");
            break;
    }
}
 
//执行扫描的动作之后，如果扫描到外设了，就会自动回调下面的协议方法了
- (void)centralManager:(CBCentralManager *)central              //中心设备
 didDiscoverPeripheral:(CBPeripheral *)peripheral               //蓝牙设备标识
     advertisementData:(NSDictionary *)advertisementData        //广播数据
                  RSSI:(NSNumber *)RSSI{                        //信号强度
    
//    if(peripheral.name){
//            NSLog(@"蓝牙设备标识:%@ 信号强度:%@ UUID:%@ 广播数据:%@",peripheral,RSSI,peripheral.identifier,advertisementData);
//    }

    NSLog(@"蓝牙设备标识:%@ 信号强度:%@ UUID:%@ 广播数据:%@",peripheral,RSSI,peripheral.identifier,advertisementData);
    
    //根据名字有选择性地连接蓝牙设备
    if([peripheral.name isEqualToString:PERIPHERAL_NAME]){
        _myPeripheral = peripheral;
        _myPeripheral.delegate = self;
        //连接外设
        [_centralManager connectPeripheral:_myPeripheral options:nil];
    }
}
 
//如果连接成功，就会回调下面的协议方法了connectperipherals
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    //停止中心管理设备的扫描动作，要不然在你和已经连接好的外设进行数据沟通时，
    //如果又有一个外设进行广播且符合你的连接条件，那么你的iOS设备也会去连接这个设备，导致数据的混乱。
    
    NSLog(@">>>连接到设备:%@ >> %@",peripheral.name, peripheral.identifier.UUIDString);
    
    if(self.connectPeripherals == nil){
        self.connectPeripherals = [NSMutableArray array];
    }
    
    if(![self.connectPeripherals containsObject:peripheral]){
        [self.connectPeripherals addObject:peripheral];
    }
    
    [_centralManager stopScan];
    //一次性读出外设的所有服务
    [_myPeripheral discoverServices:nil];
}
 
//掉线
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error{
    NSLog(@"掉线");
}
 
//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接外设:%@ 失败原因:%@", [peripheral name], [error localizedDescription]);
}

#pragma mark - CBPeripheral代理方法
//一旦我们读取到外设的相关服务UUID就会回调下面的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@">>>扫描服务:%@", peripheral.services);
    
    if(error){
        NSLog(@">>>扫描到服务:%@ 错误:%@",peripheral.name,[error localizedDescription]);
        return;
    }
    
    //到这里，说明你上面调用的  [_peripheral discoverServices:nil]; 方法起效果了，我们接着来找找特征值UUID
    for (CBService *service in [peripheral services]) {
        
        //判断服务的标识
        if([service.UUID isEqual:[CBUUID UUIDWithString:@""]]){
            
        }
        //查找特征值
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
 
//如果我们成功读取某个特征值UUID，就会回调下面的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error{
    NSLog(@"已发现可用特征...");
    if(error){
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    
    if([service.UUID isEqual:serviceUUID]){
        NSLog(@"");
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"特征 UUID: %@ (%@)", characteristic.UUID.data, characteristic.UUID);
        
        if([characteristic.UUID isEqual:characteristicUUID]){
            //情景一：通知
            /*找到特征后设置外围设备为已通知状态（订阅特征）：
             *1.调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
             *2.调用此方法会触发外围设备的订阅代理方法
             */
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            //情景二：读取
            [peripheral readValueForCharacteristic:characteristic];
            if(characteristic.value){
                NSString *vlaue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                NSLog(@"读取到特征值:%@",vlaue);
            }
        }
        
//        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0000fff6-0000-1000-8000-00805f9b34fb"]]){
//            _lockUnlockCharacteristic = characteristic;
//            NSLog(@"找到可写特征lockUnlockCharacteristic : %@", characteristic);
//        }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"0000fff4-0000-1000-8000-00805f9b34fb"]]){
//            self.readPowerCharacteristic = characteristic;
//            NSLog(@"找到可读特征readPowerCharacteristic : %@", characteristic);
//            [self.myPeripheral setNotifyValue:YES forCharacteristic:_readPowerCharacteristic];
//        }
    }
}
 
//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error{
    if(error){
        NSLog(@">>>写入命令失败:%@", error.userInfo);
    }
    else{
        NSLog(@">>>写入命令成功:%@", characteristic);
    }
}
 
//获取外设发来的数据,不论是read和notify,获取数据都从这个方法中读取
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error{
    
    if(error){
        NSLog(@"更新特征值时发生错误，错误信息:%@",error.localizedDescription);
        return;
    }
    
    if(characteristic.value){
        NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"读取到特征值:%@",value);
    }
    
    [peripheral readRSSI];
    //NSNumber* rssi = [peripheral readRSSI];
    //读取BLE4.0设备的电量
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"0000fff4-0000-1000-8000-00805f9b34fb"]]){
        NSData* data = characteristic.value;
        NSString* value = [self hexadecimalString:data];
        NSLog(@">>>读取到的: %@, data : %@, value : %@", characteristic, data, value);
    }
}
 
#pragma mark - 私有方法
//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}
 
//将传入的NSString类型转换成ASCII码并返回
- (NSData*)dataWithString:(NSString *)string{
    unsigned char *bytes = (unsigned char *)[string UTF8String];
    NSInteger len = string.length;
    return [NSData dataWithBytes:bytes length:len];
}

@end
