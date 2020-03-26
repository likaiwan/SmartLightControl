//
//  BrowserLogViewModel.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "BrowserLogViewModel.h"

@interface BrowserLogViewModel()

@property (strong, nonatomic, readwrite) NSMutableArray<LogDataModel*>* allLogs;

@end;

@implementation BrowserLogViewModel

+(instancetype)sharedInstance{
    
    static BrowserLogViewModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BrowserLogViewModel alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.filterLogText = @"";
        self.logs = [[NSMutableArray alloc] init];
        self.allLogs = [[NSMutableArray alloc] init];
        [self setObserverRegisterLogNotification];
        [self filterLogs];
    }
    return self;
}

- (void)setObserverRegisterLogNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerLogInViewModel:) name:@"RegisterLog" object:nil];
}

- (void)postReloadLogTableViewNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadLogTableView" object:self userInfo:nil];
}

- (void)registerLogInViewModel:(NSNotification*)notification {
    NSDictionary* directory = notification.userInfo;
    NSString* description = directory[@"description"];
    LogDataModel* log = [[LogDataModel alloc] initWithDesctiption:description];
    [_allLogs addObject:log];
    [self filterLogs];
}

- (void)clearLogs {
    _allLogs = [[NSMutableArray alloc] init];
    _logs = [[NSMutableArray alloc] init];
    [self postReloadLogTableViewNotification];
}

- (void)setFilterLogText:(NSString *)filterLogText {
    if (_filterLogText != filterLogText) {
        _filterLogText = filterLogText;
        [self filterLogs];
    }
}

- (void)filterLogs {
    _logs = [[NSMutableArray alloc] init];
    for (LogDataModel* log in _allLogs) {
        LogDataModel* copyLog = [[LogDataModel alloc] init];
        copyLog.logDescription = log.logDescription;
        copyLog.timestamp = log.timestamp;
        [_logs addObject:copyLog];
    }

    if (![_filterLogText isEqualToString:@""]) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"logDescription CONTAINS[cd] %@", _filterLogText];
        [_logs filterUsingPredicate:filterPredicate];
    }

    [self postReloadLogTableViewNotification];
}

- (NSString*)getLogsString {
    NSMutableString* logsString = [[NSMutableString alloc] initWithString:@"EFR Connect Logs\n"];
    for (LogDataModel* log in _logs) {
        [logsString appendString:[NSString stringWithFormat: @"%@", log.timestamp]];
        [logsString appendString:[NSString stringWithFormat: @" %@\n", log.logDescription]];
    }
    
    return logsString;
}

@end
