//
//  BrowserLogViewModel.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrowserLogViewModel : NSObject

@property (strong, nonatomic, readwrite) NSString *filterLogText;
@property (strong, nonatomic, readwrite) NSMutableArray<LogDataModel *>* logs;

+(instancetype)sharedInstance;
-(void)clearLogs;
-(NSString *)getLogsString;

@end

NS_ASSUME_NONNULL_END
