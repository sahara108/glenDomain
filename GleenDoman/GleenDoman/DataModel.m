//
//  DataModel.m
//  GleenDoman
//
//  Created by Nguyen Tuan on 17/11/2013.
//  Copyright (c) Năm 2013 Nguyen Tuan. All rights reserved.
//

#import "DataModel.h"
#import "MultiLineLable.h"

@interface DataModel ()

@end

@implementation DataModel

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark File

+ (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


+(NSArray *)lessions
{
    NSString *documentPath = [DataModel applicationDocumentsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    return [fileManager contentsOfDirectoryAtPath:documentPath error:&error];
}

+(void)initData
{
    if ([[DataModel lessions] count] == 0) {
        NSString *bundleItem = [[NSBundle mainBundle] bundlePath];
        NSString *docPath = [DataModel applicationDocumentsDirectory];
        bundleItem = [bundleItem stringByAppendingPathComponent:@"Data"];
        NSArray *alreadyItem = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleItem error:nil];
        for (NSString *dir in alreadyItem) {
            NSString *path = [bundleItem stringByAppendingPathComponent:dir];
            NSString *newPath = [docPath stringByAppendingPathComponent:dir];
            [[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:nil];
        }
    }
}

+(NSArray *)itemsInLessions:(NSString *)lession
{
    NSString *path = [[DataModel applicationDocumentsDirectory] stringByAppendingPathComponent:lession];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *arr = [dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return arr;
}

@end
