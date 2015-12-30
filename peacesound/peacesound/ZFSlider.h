//
//  ZFSlider.h
//  peacesound
//
//  Created by zhangzifei on 15/12/30.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSlider : UISlider
-(instancetype)initWithFrame:(CGRect)frame;
- (CGRect)trackRectForBounds:(CGRect)bounds;
@end
