//
//  CollectionViewCell.m
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import "CollectionViewCell.h"
#import "DataModel.h"
#import <Masonry.h>

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.iv = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iv];
        self.lab = [[UILabel alloc]init];
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lab];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.lab.mas_top);
    }];
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellData:(DataModel *)dataModel{
    self.lab.text = dataModel.price;
}
@end
