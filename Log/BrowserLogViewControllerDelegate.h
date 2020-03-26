//
//  BrowserLogViewControllerDelegate.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BrowserLogViewController;
@protocol BrowserLogViewControllerDelegate <NSObject>
- (void)logViewBackButtonPressd;
@end

NS_ASSUME_NONNULL_END
