//
//  DataModel.h
//  GleenDoman
//
//  Created by Nguyen Tuan on 17/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

+ (void)initData;
+ (NSArray*)lessions;
+ (NSArray*)itemsInLessions:(NSString*)lession;

@end
