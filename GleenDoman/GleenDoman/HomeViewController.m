//
//  HomeViewController.m
//  GleenDoman
//
//  Created by Nguyen Tuan on 15/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeGroupCell.h"
#import "HomeView.h"
#import "DataModel.h"
#import "PlaySetViewController.h"

@interface HomeViewController ()<HomeGroupCellDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *childViews;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat pagePadding;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) HomeGroupCell *currentView;
@property (nonatomic, strong) HomeGroupCell *prevView;
@property (nonatomic, strong) HomeGroupCell *nextView;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPage = 0;
    self.pagePadding = 2;
	[self setupView];
    
    self.preLoad = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewLession:)];
    [self.navigationItem setRightBarButtonItem:addButton];
}

-(void)addNewLession:(id)sender
{
    [self performSegueWithIdentifier:@"PushNewSet" sender:nil];
}

-(void)setupView{
    
}


- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //dump data
    self.dataSource = [DataModel lessions];
    
    [self reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self didRotateFromInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

#pragma mark Drawing

-(void)reloadData
{
    //calculate data at page index
    NSInteger rows,cols;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        rows = Landscape_Rows;
        cols = Landscape_Cols;
    }else {
        rows = Portrait_Rows;
        cols = Portrait_Cols;
    }
    NSInteger itemsPerPage, totalPage;
    itemsPerPage = rows * cols;
    totalPage = [self.dataSource count] / itemsPerPage;
    totalPage = totalPage * itemsPerPage < [self.dataSource count] ? totalPage + 1 : totalPage;
    self.totalPage = totalPage;
    self.currentPage = self.currentPage < 0 ? 0 : self.currentPage;
    self.currentPage = self.currentPage > totalPage - 1 ? totalPage - 1: self.currentPage;
    //calculate contentsize
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = self.scrollView.bounds.size.height;
    [self.scrollView setContentSize:CGSizeMake(w * totalPage, h)];
    
    //scroll to current page
    CGFloat offset = w * self.currentPage;
    [self.scrollView setContentOffset:CGPointMake(offset, 0)];
    
    //load current page
    [self preparePage:self.currentPage];
    [self preparePage:self.currentPage - 1];
    [self preparePage:self.currentPage + 1];
    
    if (!self.preLoad) {
        [self reloadPage:self.currentView atIndex:self.currentPage];
    }
}

- (void)preparePage:(NSInteger)page
{
    UIView *v = [self viewAtPage:page];
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = self.scrollView.bounds.size.height;
    
    CGRect r = v.frame;
    r.origin.x = page * w;
    r.origin.y = 0;
    r.size.height = h;
    v.frame = r;
    
    [((HomeGroupCell*)v) resetContentView];
    if (self.preLoad) {
        NSArray *subItems = [self itemAtIndex:page];
        if (subItems) {
            [((HomeGroupCell*)v) reloadViewWithData:subItems];
        }
    }
}

- (id)itemAtIndex:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex > self.totalPage) {
        return nil;
    }
    //calculate data at page index
    NSInteger rows,cols;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        rows = Landscape_Rows;
        cols = Landscape_Cols;
    }else {
        rows = Portrait_Rows;
        cols = Portrait_Cols;
    }
    NSInteger startIndex,endIndex,itemsPerPage;
    itemsPerPage = rows * cols;
    startIndex = pageIndex * itemsPerPage;
    endIndex = startIndex + itemsPerPage;
    endIndex = endIndex > [self.dataSource count] ? [self.dataSource count] : endIndex;
    NSArray *subItem = [self.dataSource subarrayWithRange:NSMakeRange(startIndex, endIndex - startIndex)];
    return subItem;
}

- (UIView*)viewAtPage:(NSInteger)pageNumber
{
    //get View at index
    int pos = 0;
    pos = pageNumber > self.currentPage ? 1 : pos;
    pos = pageNumber < self.currentPage ? 2 : pos;
    
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = self.scrollView.bounds.size.height;
    
    HomeGroupCell *v;
    switch (pos) {
        case 0:
            v = self.currentView;
            break;
        case 1:
            v = self.nextView;
            break;
        case 2:
            v = self.prevView;
            break;
        default:
            break;
    }
    if (!v) {
        v = [[HomeGroupCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        v.pmDelegate = self;
        [v setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
        [self.scrollView addSubview:v];
        //        v.backgroundColor = [UIColor redColor];
        CGFloat offset = pageNumber * w;
        v.frame = CGRectMake(offset, 0, w, h);
        self.currentView = pos == 0 ? v : self.currentView;
        self.prevView = pos == 2 ? v : self.prevView;
        self.nextView = pos == 1 ? v : self.nextView;
    }
    
    return v;
}

- (void)reloadPage:(UIView*)v atIndex:(NSInteger)pageNumber
{
    NSArray *subItems = [self itemAtIndex:pageNumber];
    if (subItems) {
        [((HomeGroupCell*)v) reloadViewWithData:subItems];
    }
    ((HomeGroupCell*)v).pageNumber = pageNumber;
    CGFloat w = self.scrollView.bounds.size.width;
    CGFloat h = self.scrollView.bounds.size.height;
    CGRect r = v.frame;
    r.origin.x = pageNumber * w;
    r.origin.y = 0;
    r.size.height = h;
    v.frame = r;
}

#pragma mark
#pragma mark ScrollviewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat w = self.view.bounds.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;
    
    NSInteger newPage = roundf(offset / w);
    if (newPage != self.currentPage) {
        if (newPage > self.currentPage) {
            //increase page
            HomeGroupCell *t = self.currentView;
            self.currentView = self.nextView;
            self.nextView = self.prevView;
            self.prevView = t;
            if (self.preLoad) {
                [self reloadPage:self.nextView atIndex:newPage + 1];
            }else {
                [self reloadPage:self.currentView atIndex:newPage];
                [self preparePage:newPage + 1];
            }
        }else {
            HomeGroupCell *t = self.currentView;
            self.currentView = self.prevView;
            self.prevView = self.nextView;
            self.nextView = t;
            if (self.preLoad) {
                [self reloadPage:self.prevView atIndex:newPage - 1];
            }else {
                [self reloadPage:self.currentView atIndex:newPage];
                [self preparePage:newPage - 1];
            }
        }
        self.currentPage = newPage;
    }
    self.scrollView.contentOffset = CGPointMake(offset, 0);
}

#pragma mark
#pragma mark Rotation

-(void)fixFrame
{
    CGFloat w = self.view.bounds.size.width;
    CGFloat offset = w * self.currentPage;
    NSInteger newPage = roundf(offset / w);
    CGFloat newOffset = newPage * w;
    [self.scrollView setContentOffset:CGPointMake(newOffset, 0)];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self reloadData];
    if (self.preLoad) {
        [self reloadPage:self.prevView atIndex:self.currentPage - 1];
        [self reloadPage:self.currentView atIndex:self.currentPage];
        [self reloadPage:self.nextView atIndex:self.currentPage + 1];
    }else {
        [self preparePage:self.currentPage - 1];
        [self reloadPage:self.currentView atIndex:self.currentPage];
        [self preparePage:self.currentPage + 1];
    }
    [self fixFrame];
}

-(void)didSelectItemAtIndex:(NSInteger)index
{
    NSString *dir = [self.dataSource objectAtIndex:index];
    NSArray *arr = [DataModel itemsInLessions:dir];
    [self performSegueWithIdentifier:@"PushPlaySet" sender:arr];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PlaySetViewController *dv = (PlaySetViewController*)[segue destinationViewController];
    if ([dv isKindOfClass:[PlaySetViewController class]]) {
        dv.dataSource = sender;
    }
}

@end
