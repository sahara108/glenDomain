//
//  HomeGroupCell.m
//  GleenDoman
//
//  Created by Nguyen Tuan on 17/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import "HomeGroupCell.h"
#import "HomeCell.h"
#import "Drawer.h"

#define Base_Tag 1011
#define Pading 10

@interface HomeGroupCell ()
@property (nonatomic, assign) BOOL runThread;
@property (nonatomic, strong) Drawer *drawer;
@end

@implementation HomeGroupCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.runThread = NO;
        self.drawer = [[Drawer alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger rows,cols;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        rows = Landscape_Rows;
        cols = Landscape_Cols;
    }else {
        rows = Portrait_Rows;
        cols = Portrait_Cols;
    }
    CGFloat w,h;
    w = (self.bounds.size.width - (cols + 1) * Pading) / cols;
    h = (self.bounds.size.height - (rows + 1) * Pading) / rows;
    
    NSInteger itemsPerPage;
    itemsPerPage = rows * cols;
    HomeCell *cell = nil;
    int i = 0;
    
    for (; i < itemsPerPage; i++) {
        cell = (HomeCell*)[self viewWithTag:(Base_Tag + i)];
        if (!cell) {
            cell = [[HomeCell alloc] initWithFrame:CGRectZero];
            cell.backgroundColor = [UIColor grayColor];
            cell.layer.cornerRadius = 3;
            [cell setTag:(Base_Tag + i)];
            [self addSubview:cell];
        }
        CGRect r = cell.frame;
        NSInteger col, row;
        row = i / cols;
        col = i % cols;
        r.origin.x = (col + 1) * Pading + col * w;
        r.origin.y = (row + 1) * Pading + row * h;
        r.size.width = w;
        r.size.height = h;
        cell.frame = r;
    }
    
    i ++;
    cell = (HomeCell*)[self viewWithTag:(Base_Tag + i)];
    while (cell) {
        cell.hidden = YES;
        i++;
        cell = (HomeCell*)[self viewWithTag:(Base_Tag + i)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)resetContentView
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[HomeCell class]]) {
            ((HomeCell*)v).image = nil;
        }
    }
}

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
        HomeCell *cell = (HomeCell*)[self viewWithTag:(i + Base_Tag)];
        UIImage *img = [self.drawer imageWithText:text inView:cell];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.image = img;
        });
        i++;
    }
    [NSThread exit];
}

#pragma mark Actions

-(id)cellForItemAtIndex:(NSInteger)index
{
    NSInteger itemsPerPage = [self.subviews count];
    NSInteger subIndex = index % itemsPerPage;
    return [self viewWithTag:(subIndex + Base_Tag)];
}

-(void)didTapView:(UITapGestureRecognizer*)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    NSInteger subIndex;
    for (UIView *v in self.subviews) {
        CGRect r = v.frame;
        if (CGRectContainsPoint(r, tapPoint)) {
            NSInteger tag = v.tag;
            subIndex = tag - Base_Tag;
            break;
        }
    }
    NSInteger itemsPerPage = [self.subviews count];
    NSInteger index = itemsPerPage * self.pageNumber + subIndex;
    if ([self.pmDelegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.pmDelegate didSelectItemAtIndex:index];
    }
}

@end
