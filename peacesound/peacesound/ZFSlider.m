//
//  ZFSlider.m
//  peacesound
//
//  Created by zhangzifei on 15/12/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "ZFSlider.h"

@implementation ZFSlider

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
    }
    return self;
}
-(CGRect)trackRectForBounds:(CGRect)bounds{

    return CGRectMake(0, 11, 200, 3);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
