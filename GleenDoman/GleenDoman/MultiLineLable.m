//
//  WCMultiLineLable.m
//  WifiCam
//
//  Created by natuan-partner on 10/25/13.
//  Copyright (c) 2013 IVC. All rights reserved.
//

#import "MultiLineLable.h"

@implementation MultiLineLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            self.lineBreakMode = NSLineBreakByWordWrapping;
            self.textAlignment = NSTextAlignmentCenter;
        }else {
            self.lineBreakMode = UILineBreakModeWordWrap;
            self.textAlignment = UITextAlignmentCenter;
        }
        self.textColor = [UIColor greenColor];
        self.font = [UIFont boldSystemFontOfSize:25];
        
        self.numberOfLines = 0;
    }
    return self;
}

- (UIImage *)imageFromLayer
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
