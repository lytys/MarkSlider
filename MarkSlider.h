//
//  MarkSlider.h
//  testSlider
//
//  Created by tianyongsheng on 15/12/23.
//  Copyright © 2015年 tianyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MarkerValueDelegate <NSObject>

@optional
-(void)markValue:(NSUInteger)value;
-(NSUInteger)markCurrentValue;

@end

@interface MarkSlider : UISlider

@property(nonatomic,strong) UIColor *markColor;
@property(nonatomic,assign) CGFloat markWidth;
@property(nonatomic,strong) UIColor *selectedBarColor;
@property(nonatomic,strong) UIColor *unselectedBarColor;
@property(nonatomic,strong) UIImage *handlerImage;
@property(nonatomic,strong) UIColor *handlerColor;


@property(nonatomic,weak) id<MarkerValueDelegate> delegate;

@end
