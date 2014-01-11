//
//  Drawer.m
//  GleenDoman
//
//  Created by Nguyen Tuan on 21/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import "Drawer.h"
#import "MultiLineLable.h"

@interface Drawer ()

@property (nonatomic, strong) MultiLineLable *drawer;

@end

@implementation Drawer

-(id)init
{
    self = [super init];
    if (self) {
        self.drawer = [[MultiLineLable alloc] init];
    }
    return self;
}

#pragma mark Drawer

-(UIImage *)imageWithText:(NSString *)text inView:(UIView *)view
{
    UIImage *img = nil;
    @synchronized(self.drawer){
        if (!CGRectEqualToRect(view.bounds, CGRectZero)) {
            [self.drawer setFrame:view.bounds];
            self.drawer.text = [self nomarlizeText:text];
            img = [self.drawer imageFromLayer];
        }
    }
    return img;
}

-(NSString*)nomarlizeText:(NSString*)inputText
{
    NSArray *items = [inputText componentsSeparatedByString:@"."];
    return items[0];
}
@end
