//
//  TSInspectStandardModel.m
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSInspectStandardModel.h"

@implementation TSInspectStandardModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"TSInspectStandardModelUndefinedKey:%@",key);
}
@end
