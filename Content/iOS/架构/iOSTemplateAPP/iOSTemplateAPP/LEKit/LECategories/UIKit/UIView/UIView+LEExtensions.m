//
//  UIView+LEExtensions.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/21.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "UIView+LEExtensions.h"

@implementation UIView (LEExtensions)

- (void)lee_removeAllSubviews {
    
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    
}
@end
