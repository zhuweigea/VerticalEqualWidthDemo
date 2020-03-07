//
//  WaterfallFlowLayout.h
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterfallFlowLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol WaterfallFlowLayoutDelegate <NSObject>
@required
//item heigh
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;
@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface WaterfallFlowLayout : UICollectionViewLayout
@property(nonatomic,assign)UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic,assign)CGFloat lineSpacing;  //line space
@property(nonatomic,assign)CGFloat itemSpacing; //item space
@property(nonatomic,assign)CGFloat colCount; //column count
@property(nonatomic,weak)id<WaterfallFlowLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
