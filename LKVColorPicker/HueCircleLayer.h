//
//  HueCircleLayer.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//
//  大色环
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HueCircleLayer : CALayer
{
    unsigned int subDivisions;
}

@property (assign) unsigned int subDivisions;

@end

NS_ASSUME_NONNULL_END
