//
//  TSInspectStandardModel.h
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSInspectStandardModel : NSObject

@property (nonatomic,assign) int inspectInstanceId;//检查任务ID
@property (nonatomic,assign) int inspectStandardId;//检查标准ID
@property (nonatomic,copy) NSString *inspectStandardName;//检查标准名称
@property (nonatomic,assign) int isDelete;//是否删除

@end
