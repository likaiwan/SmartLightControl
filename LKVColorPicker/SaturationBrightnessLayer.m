//
//  SaturationBrightnessLayer.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/1/10.
//  Copyright © 2020 李凯. All rights reserved.
//
//  画圆圈
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "SaturationBrightnessLayer.h"

@implementation SaturationBrightnessLayer

-(id)initWithContext:(CAEAGLLayer *) context
{
    self = [super init];
    if (self)
    {
        self.opaque = YES;
        glContext = context;
        [EAGLContext setCurrentContext:glContext];
        glGenRenderbuffers(1, &renderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
        [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
        
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
        
        [self loadShaders];
    }
    return self;
}

- (void)dealloc
{
    if (framebuffer)
    {
        glDeleteFramebuffers(1, &framebuffer);
        framebuffer = 0;
    }
    
    if (renderbuffer)
    {
        glDeleteRenderbuffers(1, &renderbuffer);
        renderbuffer = 0;
    }
    
    // realease the shader program object
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
    
    // tear down context
    if ([EAGLContext currentContext] == glContext)
        [EAGLContext setCurrentContext:nil];
    
    glContext = nil;
}

- (void)layoutSublayers
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
}

- (void)loadShaders
{
    // create shader program
    program = glCreateProgram();
    
    const GLchar * vertexProgram = "precision highp float; \n\
        \n\
        attribute vec4 position; \n\
        varying vec2 uv; \n\
        \n\
        void main() \n\
        { \n\
            gl_Position = vec4(2.0 * position.x - 1.0, 2.0 * position.y - 1.0, 0.0, 1.0); \n\
            uv = position.xy; \n\
        }";
    
    //创建着色器对象
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    
    glShaderSource(vertexShader, 1, &vertexProgram, NULL);
    
    //编译着色器
    glCompileShader(vertexShader);
    //将着色器附加到程序上
    glAttachShader(program, vertexShader);

    // https://gist.github.com/eieio/4109795
    const GLchar * fragmentProgram = "precision highp float; \n\
    varying vec2 uv; \n\
    uniform float hue; \n\
    vec3 hsb_to_rgb(float h, float s, float l) \n\
    { \n\
        float c = l * s; \n\
        h = mod((h * 6.0), 6.0); \n\
        float x = c * (1.0 - abs(mod(h, 2.0) - 1.0)); \n\
        vec3 result; \n\
         \n\
        if (0.0 <= h && h < 1.0) { \n\
            result = vec3(c, x, 0.0); \n\
        } else if (1.0 <= h && h < 2.0) { \n\
            result = vec3(x, c, 0.0); \n\
        } else if (2.0 <= h && h < 3.0) { \n\
            result = vec3(0.0, c, x); \n\
        } else if (3.0 <= h && h < 4.0) { \n\
            result = vec3(0.0, x, c); \n\
        } else if (4.0 <= h && h < 5.0) { \n\
            result = vec3(x, 0.0, c); \n\
        } else if (5.0 <= h && h < 6.0) { \n\
            result = vec3(c, 0.0, x); \n\
        } else { \n\
            result = vec3(0.0, 0.0, 0.0); \n\
        } \n\
     \n\
    result.rgb += l - c; \n\
     \n\
    return result; \n\
    } \n\
     \n\
    void main() \n\
    { \
        gl_FragColor = vec4(hsb_to_rgb(hue, uv.x, uv.y), 1.0); \
    }";

    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentProgram, NULL);
    glCompileShader(fragmentShader);
    glAttachShader(program, fragmentShader);
    
    // bind attribute locations
    // this needs to be done prior to linking
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    
    //链接着色器程序
    glLinkProgram(program);
    
    //释放资源
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

- (void)setHue:(CGFloat)value
{
    hue = value;
    [self setNeedsDisplay];
}

- (CGFloat)hue
{
    return hue;
}

- (void)display
{
    // Draw a frame
    [EAGLContext setCurrentContext:glContext];
    
    const GLfloat squareVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    // use shader program
    glUseProgram(program);

    glUniform1f(glGetUniformLocation(program, "hue"), hue);
    
    // 设置顶点属性和数据
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    // 绘制
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
//    const GLubyte indices[] = {0, 1, 2, 3};
//    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, indices);
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
