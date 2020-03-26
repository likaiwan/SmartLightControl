//
//  LogDataModel.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogDataModel : NSObject

@property (nonatomic, strong, readwrite) NSString* timestamp;
@property (nonatomic, strong, readwrite) NSString* logDescription;

- (instancetype)initWithDesctiption:(NSString*)description;
+ (NSString *)prepareLogDescription:(NSString*)title andPeripheral:(CBPeripheral *)peripheral andError:(NSError*)error;
+ (NSString *)prepareLogDescription:(NSString *)title andCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral andError:(NSError *)error;
+ (NSString *)prepareLogDescription:(NSString *)title andDescriptor:(CBDescriptor *)descriptor andPeripheral:(CBPeripheral *)peripheral andError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
