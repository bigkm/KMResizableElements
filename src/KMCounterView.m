//
//  KMDisclosueButtonView.m
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMCounterView.h"

@implementation KMCounterView
@synthesize text = _text;
@synthesize innerColor = _innerColor;
@synthesize outerColor = _outerColor;

- (void)defaultSettings
{
    [self setClearsContextBeforeDrawing:YES];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSettings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self defaultSettings];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if (text != _text && ![text isEqualToString:_text])
    {
        [_text release];
        _text = [text retain];
        [self setNeedsDisplay];
    }
}

- (NSString *)text
{
    return [[_text retain] autorelease];
}

- (void)dealloc
{
    [_text release];
    [_innerColor release];
    [_outerColor release];
    [super dealloc];
}

- (void)drawTextCenteredInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [(_outerColor ?: [UIColor whiteColor]) setFill];
    CGContextSetShadow(context, CGSizeMake(0.0, -1.0), 0.0);
    
    CGFloat fontSize = floorf(rect.size.height * 0.76);
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
    CGRect textRect;
    UILineBreakMode breakMode = UILineBreakModeTailTruncation;
    CGSize textSize = [_text sizeWithFont:font 
                              minFontSize:2.0 
                           actualFontSize:&fontSize
                                 forWidth:fontSize 
                            lineBreakMode:UILineBreakModeTailTruncation];
    font = [UIFont boldSystemFontOfSize: fontSize];
    textSize = [_text sizeWithFont:font forWidth:textSize.width lineBreakMode:breakMode];
    textRect.size = textSize;
    textRect.origin = CGPointMake(CGRectGetMidX(rect)-(textSize.width/2), CGRectGetMidY(rect)-(font.lineHeight/2));
    textRect = CGRectIntegral(textRect);
    [_text drawInRect:textRect withFont:font lineBreakMode:breakMode];
    CGContextRestoreGState(context);
}

#define COLOR_CoolBlue [UIColor colorWithRed:COLOR2PERC(35.f) green:COLOR2PERC(110.0f) blue:COLOR2PERC(216.f) alpha:1.0]
#define COLOR2PERC(c) ((CGFloat)((c)/255))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGRect r = self.bounds;
    CGFloat insetPercentage = 0.1f;
    CGRect mainRect = CGRectIntegral(CGRectInset(r, r.size.width*insetPercentage, r.size.height*insetPercentage));
    mainRect.origin.y /= 2;  // shift up so shadow isn't cut at bottom
    
    [(_outerColor ?: [UIColor whiteColor]) setStroke];
    [(_innerColor ?: [UIColor redColor]) setFill];
    CGContextSetLineWidth(context, mainRect.size.width * insetPercentage * 0.8);

    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0, (r.size.width-mainRect.size.width)/5), (r.size.width-mainRect.size.width)/3);
    CGContextAddEllipseInRect(context, mainRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    if ([_text length] != 0)
    {
        [self drawTextCenteredInRect:mainRect];
    }
    
    // ===== Apply Gloss =====
    CGContextSaveGState(context);
    CGContextBeginPath(context); 
    CGRect glossRect = rect;
    glossRect = CGRectIntegral(CGRectInset(glossRect, glossRect.size.width * -0.3, glossRect.size.height * -0.3));
    glossRect.origin.y = roundf((CGRectGetMidY(mainRect) * 1.3) - glossRect.size.height);
    
    
    // build intersection of both circles as the clip mask
    CGContextAddEllipseInRect(context, glossRect);
    CGContextClip(context);
    // this rect is on the outsid of the border circle
    CGContextAddEllipseInRect(context, CGRectInset(mainRect, mainRect.size.width * insetPercentage * -0.8/2, mainRect.size.width * insetPercentage * -0.8/2));
    CGContextClip(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locs[] = {0.0f, 1.0f};
    CGColorRef colorRefs[] = {  [[UIColor colorWithWhite:1.0 alpha:0.8] CGColor],
                                [[UIColor colorWithWhite:1.0 alpha:0.2] CGColor]};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRefs, sizeof(colorRefs) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    CGGradientRef glossGradient = CGGradientCreateWithColors(colorSpace, colors, locs);
    CGColorSpaceRelease(colorSpace);
    CFRelease(colors);

    // draw gradient
    CGContextDrawLinearGradient(context, glossGradient, r.origin, CGPointMake(0.0, CGRectGetMaxY(glossRect)+2), kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(glossGradient);
    CGContextRestoreGState(context);
}



@end
