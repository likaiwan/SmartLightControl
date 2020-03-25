//
//  SaturationBrightnessLayer.h
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//
//  画圆圈
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaturationBrightnessLayer : CAEAGLLayer
{
    CGFloat hue;
    EAGLContext * glContext;
    GLuint framebuffer;
    GLuint renderbuffer;
    GLuint program;
    //EAGLSharegroup
    
//    //发射器层，用来控制粒子效果
//    CAEmitterLayer;
    
    //
    
    enum{
        ATTRIB_VERTEX,
        ATTRIB_COLOR,
        NUM_ATTRIBUTES
    };
}

@property (assign) CGFloat hue;

@end

NS_ASSUME_NONNULL_END
