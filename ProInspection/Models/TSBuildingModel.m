//
//  TSBuildingModel.m
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSBuildingModel.h"

@implementation TSBuildingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"TSBuildingModelUndefinedKey:%@",key);
}
@end
