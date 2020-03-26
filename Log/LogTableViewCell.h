//
//  LogTableViewCell.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/25.
//  Copyright © 2020 李凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogTableViewCell : UITableViewCell

- (void)setValues:(LogDataModel *)log;

@end

NS_ASSUME_NONNULL_END
