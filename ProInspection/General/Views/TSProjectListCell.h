//
//  TSProjectListCell.h
//  ProInspection
//
//  Created by Aries on 14-7-10.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    loadBeginType = 0,// 点击开始下载
    loadContinueType ,//继续下载
    loadPauseType,//暂停下载
    loadCompliteType,// 下载完成
    updateType//更新
    
}DownloadStatusType;

@protocol TSProjectListCellDelegate <NSObject>

@optional
// 点击下载按钮
- (void)resumeDownloadProjectWith:(int)treeId downloadStatus:(DownloadStatusType)status indexPath:(NSIndexPath *)indexPath;
// 点击检查任务编辑按钮进入选择楼栋界面
- (void)checkProjectWithTreeId:(int)treeId;

@end


@interface TSProjectListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *treeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *checkProjectButton;
@property (assign, nonatomic) int treeId;
@property (strong, nonatomic) NSIndexPath *indexpath;

@property (weak, nonatomic) id<TSProjectListCellDelegate>delegate;

@end
