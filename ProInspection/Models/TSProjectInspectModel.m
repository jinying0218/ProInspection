//
//  TSProjectModel.m
//  ProInspection
//
//  Created by Aries on 14-7-8.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSProjectInspectModel.h"

@implementation TSProjectInspectModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"TSProjectModelUndefinedKey:%@",key);
}

@end
