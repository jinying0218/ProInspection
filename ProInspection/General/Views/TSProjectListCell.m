//
//  TSProjectListCell.m
//  ProInspection
//
//  Created by Aries on 14-7-10.
//  Copyright (c) 2014年 Sagitar. All rights reserved.
//

#import "TSProjectListCell.h"

@interface TSProjectListCell()



@end

@implementation TSProjectListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (IBAction)downloadButtonOnClick:(UIButton *)sender
{
    NSLog(@"下载");
    if ([self.delegate respondsToSelector:@selector(resumeDownloadProjectWith:downloadStatus:indexPath:)])
    {
        [self.delegate resumeDownloadProjectWith:self.treeId downloadStatus:loadBeginType  indexPath:self.indexpath];
    }
}

- (IBAction)checkButtonOnClick:(UIButton *)sender
{
    NSLog(@"查看项目");
    if ([self.delegate respondsToSelector:@selector(checkProjectWithTreeId:)])
    {
        [self.delegate checkProjectWithTreeId:self.treeId];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
