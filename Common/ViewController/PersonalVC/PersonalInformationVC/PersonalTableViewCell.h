//
//  PersonalTableViewCell.h
//  个人信息
//
//  Created by lixiaofeng on 16/3/21.
//  Copyright © 2016年 lixiaofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *personImageView;

@property (strong, nonatomic) IBOutlet UILabel *personText;

@property (strong, nonatomic) IBOutlet UILabel *detailPersonText;

@end
