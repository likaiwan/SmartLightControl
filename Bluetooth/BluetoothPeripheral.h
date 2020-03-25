//
//  BluetoothPeripheral.h
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

@interface BluetoothPeripheral : NSObject

@end

NS_ASSUME_NONNULL_END
