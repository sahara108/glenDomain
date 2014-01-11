//
//  PlayCell.m
//  GleenDoman
//
//  Created by Nguyen Tuan on 20/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import "PlayCell.h"
#import "Drawer.h"

@interface PlayCell ()

@property (nonatomic, assign) BOOL runThread;
@property (nonatomic, strong) Drawer *drawer;

@end

@implementation PlayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.drawer = [[Drawer alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)reloadViewWithData:(NSArray *)data
{
    //stop any current thread
    self.runThread = NO;
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //make another thread
        self.runThread = YES;
        NSThread *newThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMakeDataForRendering:) object:data];
        [newThread start];
    });
}

#pragma mark Threading Function

//do not call this function directly
-(void)threadMakeDataForRendering:(NSArray*)data
{
    int i = 0;
    while (self.runThread && i < [data count]) {
        //do something
        NSString *text = [data objectAtIndex:i];
        UIImage *img = [self.drawer imageWithText:text inView:self];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.image = img;
        });
        i++;
    }
    [NSThread exit];
}

-(void)resetContentView
{
    self.image = nil;
}

@end
