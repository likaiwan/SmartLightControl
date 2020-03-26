//
//  LogDataModel.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "LogDataModel.h"

@implementation LogDataModel

- (instancetype)initWithDesctiption:(NSString*)description {
    self = [super init];
    if (self) {
        self.timestamp = [self getCurrentTime];
        self.logDescription = description;
    }
    return self;
}

- (NSString *)getCurrentTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.mmm"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
}

+ (NSString *)prepareLogDescription:(NSString*)title andPeripheral:(CBPeripheral *)peripheral andError:(NSError*)error {
    NSMutableString* description = [NSMutableString stringWithString:title];
    if (peripheral.name != nil) {
        [description appendString:peripheral.name];
    } else {
        [description appendString:@"Unknown pepipheral"];
    }
    [description appendString:@" ("];
    [description appendString:peripheral.identifier.UUIDString];
    [description appendString:@")"];
    if (error != nil) {
        [description appendString:[NSString stringWithFormat:@"\nerror code: %ld", (long)error.code]];
    }
    return description;
}

+ (NSString *)prepareLogDescription:(NSString *)title andCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral andError:(NSError *)error {
    NSMutableString* description = [NSMutableString stringWithString:title];
    if (peripheral.name != nil) {
        [description appendString:peripheral.name];
    } else {
        [description appendString:@"Unknown pepipheral"];
    }
    [description appendString:@" ("];
    [description appendString:peripheral.identifier.UUIDString];
    [description appendString:@")"];
    
    if (characteristic != nil) {
        [description appendString:[NSString stringWithFormat:@"\ncharacterictic with UUID: %@", characteristic.UUID.UUIDString]];
    }
    
    if (error != nil) {
        [description appendString:[NSString stringWithFormat:@"\nerror code: %ld", (long)error.code]];
    }
    return description;
}

+ (NSString *)prepareLogDescription:(NSString *)title andDescriptor:(CBDescriptor *)descriptor andPeripheral:(CBPeripheral *)peripheral andError:(NSError *)error {
    NSMutableString* description = [NSMutableString stringWithString:title];
    if (peripheral.name != nil) {
        [description appendString:peripheral.name];
    } else {
        [description appendString:@"Unknown pepipheral"];
    }
    [description appendString:@" ("];
    [description appendString:peripheral.identifier.UUIDString];
    [description appendString:@")"];
    
    if (descriptor != nil) {
        [description appendString:[NSString stringWithFormat:@"\ndescriptor with UUID: %@", descriptor.UUID.UUIDString]];
    }
    
    if (error != nil) {
        [description appendString:[NSString stringWithFormat:@"\nerror code: %ld", (long)error.code]];
    }
    return description;
}

@end
