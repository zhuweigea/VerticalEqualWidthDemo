//
//  WaterfallFlowLayout.m
//  demo19
//
//  Created by 朱伟阁 on 2020/3/6.
//  Copyright © 2020 朱伟阁. All rights reserved.
//

#import "WaterfallFlowLayout.h"
/*      默认值    */
static const CGFloat inset = 10;
static const CGFloat colCount = 3;

@interface WaterfallFlowLayout ()
//字典存放每一列的高度 key对应第几列 value对应列高
@property (nonatomic, strong) NSMutableDictionary *colunMaxYDic;
@property (nonatomic, strong) NSMutableArray *attrsArr;
@end

@implementation WaterfallFlowLayout
//也可是使用代理设置WaterfallFlowLayout的布局约束 类似于设置sectionheader sectionfooter
- (instancetype)init
{
    if (self=[super init]) {
        self.itemSpacing = inset;
        self.lineSpacing = inset;
        self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        self.colCount = colCount;
        self.colunMaxYDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)prepareLayout{
    [super prepareLayout];
    for(NSInteger i = 0;i < self.colCount; i++)
    {
        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
        self.colunMaxYDic[col] = @(0);
    }
    self.attrsArr = [NSMutableArray array];
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0 ; i < section; i++) {
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [self.attrsArr addObject:headerAttrs];
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [self.attrsArr addObject:attrs];
        }
        //获取footer的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [self.attrsArr addObject:footerAttrs];
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //标记最短列的索引(位于第几列)
    __block NSString *minCol = @"0";
    //遍历找出最短的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if([maxY floatValue] < [self.colunMaxYDic[minCol] floatValue]){
            minCol = column;
        }
    }];
    //item宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right- (self.colCount-1) * self.itemSpacing)/self.colCount;
    //item高度
    CGFloat height = 0;
    if([self.delegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]){
        height = [self.delegate collectionView:self.collectionView layout:self heightForWidth:width atIndexPath:indexPath];
    }
    //item的x坐标(以屏幕边缘作为起始点)
    CGFloat x = self.sectionInset.left+(width+self.itemSpacing)*[minCol intValue];
    CGFloat y;
    //item之间的行间距
    CGFloat space = 0.0;
    //item的索引小于总列数,则位于第一行
    if(indexPath.item < self.colCount){
        space = 0.0;
        //位于每一组的第一行需要加上内边距的top
        y = [self.colunMaxYDic[minCol] floatValue]+space+self.sectionInset.top;
    }else{
        space = self.lineSpacing;
        //不位于每一组的第一行不需要加内边距的top
        y = [self.colunMaxYDic[minCol] floatValue]+space;
    }
    //更新对应列的高度
    self.colunMaxYDic[minCol] = @(y + height);
    //取得每一组
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    __block NSString * maxCol = @"0";
    //是否是每一组的最后一个item
    if(indexPath.item == (itemCount-1)){
        //遍历出最高列的高度加上内边距的bottom 然后更新最高列的高度
        [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
            if ([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]) {
                maxCol = column;
                CGFloat maxH = [self.colunMaxYDic[maxCol] floatValue];
                maxH += self.sectionInset.bottom;
                self.colunMaxYDic[maxCol] = @(maxH);
            }
        }];
    }
    //    计算位置
    UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, height);
    return attri;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    __block NSString *maxCol = @"0";
    //遍历找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]){
            maxCol = column;
        }
    }];
    //计算header的UICollectionViewLayoutAttributes
    if([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        //header的大小
        CGSize size = CGSizeZero;
        if([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]){
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        //组头靠屏幕边缘的坐标
        CGFloat x = 0;
        //取得最高列的高度
        CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue];
        //更新所有对应列的高度
        for (NSString *key in self.colunMaxYDic.allKeys) {
            self.colunMaxYDic[key] = @(y+size.height);
        }
        attri.frame = CGRectMake(x, y, size.width, size.height);
        return attri;
    }else{
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        //footer的大小
        CGSize size = CGSizeZero;
        if([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]){
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        CGFloat x = 0;
        CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue];
        //更新所有对应列的高度
        for (NSString *key in self.colunMaxYDic.allKeys) {
            self.colunMaxYDic[key] = @(y+size.height);
        }
        attri.frame = CGRectMake(x, y, size.width, size.height);
        return attri;
    }
}
- (CGSize)collectionViewContentSize{
    __block NSString *maxCol = @"0";
    //遍历找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column,NSNumber *maxY, BOOL *stop) {
        if([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]){
            maxCol = column;
        }
    }];
    return CGSizeMake(0, [self.colunMaxYDic[maxCol] floatValue]);
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArr;
}
@end
