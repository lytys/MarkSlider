//
//  MarkSlider.m
//  testSlider
//
//  Created by tianyongsheng on 15/12/23.
//  Copyright © 2015年 tianyongsheng. All rights reserved.
//

#import "MarkSlider.h"


@interface MarkSlider (){
    
}

@property(nonatomic,strong) NSArray *markPositions;

@end

@implementation MarkSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.markColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:124/255.0 alpha:0.7];
        self.markWidth = 1.0;
        self.selectedBarColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:193/255.0 alpha:0.8];
        self.unselectedBarColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:94/255.0 alpha:0.8];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.markColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:124/255.0 alpha:0.7];
        self.markWidth = 1.0;
        self.selectedBarColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:193/255.0 alpha:0.8];
        self.unselectedBarColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:94/255.0 alpha:0.8];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat w = rect.size.width;

    self.markPositions = @[@15,@(15 + (w-30)/5.0),@(15 + (w-30)*2/5.0),@(15 + (w-30)*3/5.0),@(15 + (w-30)*4/5.0),@(w-15)];
    
    self.minimumValue = 1;
    self.maximumValue = self.markPositions.count ;

    
    CGRect innerRect = rect;
    UIGraphicsBeginImageContextWithOptions(innerRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Selected side
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);


    CGContextMoveToPoint(context, 15, CGRectGetHeight(innerRect)/2);
    CGContextAddLineToPoint(context, innerRect.size.width-15, CGRectGetHeight(innerRect)/2);
    CGContextSetStrokeColorWithColor(context, [self.selectedBarColor CGColor]);
    CGContextStrokePath(context);
    UIImage *selectedSide = UIGraphicsGetImageFromCurrentImageContext();
    
    // Unselected side
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);

    CGContextMoveToPoint(context, 15, CGRectGetHeight(innerRect)/2);
    CGContextAddLineToPoint(context, innerRect.size.width-15, CGRectGetHeight(innerRect)/2);
    CGContextSetStrokeColorWithColor(context, [self.unselectedBarColor CGColor]);
    CGContextStrokePath(context);
    UIImage *unselectedSide = UIGraphicsGetImageFromCurrentImageContext();
    
    // Set trips on selected side
    [selectedSide drawAtPoint:CGPointMake(0,0)];
    for (int i = 0; i < [self.markPositions count]; i++) {
        CGContextSetLineWidth(context, self.markWidth);
        float position = [self.markPositions[i]floatValue];
        CGContextMoveToPoint(context, position, CGRectGetHeight(innerRect)/2 - 5);
        CGContextAddLineToPoint(context, position, CGRectGetHeight(innerRect)/2);
        CGContextSetStrokeColorWithColor(context, [self.markColor CGColor]);
        CGContextStrokePath(context);
    }
    UIImage *selectedStripSide = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    // Set trips on unselected side
    [unselectedSide drawAtPoint:CGPointMake(0,0)];
    for (int i = 0; i < [self.markPositions count]; i++) {
        CGContextSetLineWidth(context, self.markWidth);
        float position = [self.markPositions[i]floatValue];
        CGContextMoveToPoint(context, position, CGRectGetHeight(innerRect)/2 - 5);
        CGContextAddLineToPoint(context, position, CGRectGetHeight(innerRect)/2);
        CGContextSetStrokeColorWithColor(context, [self.markColor CGColor]);
        CGContextStrokePath(context);
    }
    UIImage *unselectedStripSide = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    UIGraphicsEndImageContext();
    
    [self setMinimumTrackImage:selectedStripSide forState:UIControlStateNormal];
    [self setMaximumTrackImage:unselectedStripSide forState:UIControlStateNormal];
    if (self.handlerImage != nil) {
        [self setThumbImage:self.handlerImage forState:UIControlStateNormal];
    } else if (self.handlerColor != nil) {
        [self setThumbImage:[UIImage new] forState:UIControlStateNormal];
        [self setThumbTintColor:self.handlerColor];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(markCurrentValue)]) {
        self.value = [self.delegate markCurrentValue];
    }
    
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}


-(void)valueChanged:(UISlider *)slider{
    
    slider.value = roundf(slider.value);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(markValue:)]) {
        [self.delegate markValue:(NSUInteger)self.value];
    }
    
}

-(void)tapAction:(UITapGestureRecognizer *)recognizer{
    float x = [recognizer locationInView:self].x;
    
   float pos =  roundf(x / self.frame.size.width * (self.markPositions.count - 1)* 1.0) + 1 ;
    
    self.value = pos;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(markValue:)]) {
        [self.delegate markValue:(NSUInteger)self.value];
    }
    
}

@end
