//
//  BrowserLogViewController.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserLogViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrowserLogViewController : UIViewController

@property (retain, nonatomic) id<BrowserLogViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
