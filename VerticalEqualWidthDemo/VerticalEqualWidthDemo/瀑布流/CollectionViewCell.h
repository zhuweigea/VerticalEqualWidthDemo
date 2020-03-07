//
//  CollectionViewCell.h
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *lab;
@property (strong, nonatomic) UIImageView *iv;
- (void)setCellData:(DataModel *)dataModel;
@end

NS_ASSUME_NONNULL_END
