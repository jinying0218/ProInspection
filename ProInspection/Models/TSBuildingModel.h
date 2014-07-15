//
//  TSBuildingModel.h
//  ProInspection
//
//  Created by Aries on 14-7-9.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSBuildingModel : NSObject

@property (nonatomic,assign) int buildingId;
@property (nonatomic,assign) int biaoduanId;
@property (nonatomic,copy) NSString *buildingName;
@property (nonatomic,copy) NSString *buildingType;
@property (nonatomic,assign) int fenqiId;
@property (nonatomic,assign) int inspectInstanceBuildingId;
@property (nonatomic,assign) int inspectInstanceId;
@property (nonatomic,assign) int isDelete;
@property (nonatomic,assign) int isInspect;
@property (nonatomic,assign) int zutuanId;

@end
