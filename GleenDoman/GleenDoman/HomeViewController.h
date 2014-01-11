//
//  HomeViewController.h
//  GleenDoman
//
//  Created by Nguyen Tuan on 15/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL preLoad;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end
