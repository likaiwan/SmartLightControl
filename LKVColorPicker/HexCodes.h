//
//  HexCodes.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexCodes)

- (NSString *)formatHexCode;

/**
 *  判断三色值是否在色温的范围内
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *
 */
- (BOOL)getColor:(CGFloat *)red withGreen:(CGFloat *)green withBlue:(CGFloat *)blue;

/**
 *  获取颜色的三色值 范围（0~255）
 *
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 */
- (void)getColorWithRed:(CGFloat *)red withGreen:(CGFloat *)green withBlue:(CGFloat *)blue;

@end

NS_ASSUME_NONNULL_END
