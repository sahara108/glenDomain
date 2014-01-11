//
//  HomeGroupCell.h
//  GleenDoman
//
//  Created by Nguyen Tuan on 17/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Portrait_Rows 2
#define Portrait_Cols 2
#define Landscape_Rows 2
#define Landscape_Cols 2

@protocol HomeGroupCellDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface HomeGroupCell : UIView

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) id<HomeGroupCellDelegate> pmDelegate;

- (void)reloadViewWithData:(NSArray*)data;
- (void)resetContentView;

@end
