//
//  YHASCollectionLayoutDelegate.m
//  HiFanSmooth
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHASCollectionLayoutDelegate.h"
#import <Texture/AsyncDisplayKit/ASCollectionElement.h>


@interface YHASCollectionLayoutInfo : NSObject

// Read-only properties
@property (nonatomic, assign, readonly) NSInteger numberOfColumns;
@property (nonatomic, assign, readonly) CGFloat columnSpacing;
@property (nonatomic, assign, readonly) UIEdgeInsets sectionInsets;
@property (nonatomic, assign, readonly) CGFloat interItemSpacing;


- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


@implementation YHASCollectionLayoutInfo
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
{
    self = [super init];
    if (self) {
        _numberOfColumns = numberOfColumns;
        _columnSpacing = columnSpacing;
        _interItemSpacing = interItemSpacing;
        _sectionInsets = sectionInsets;
    }
    return self;
}


- (BOOL)isEqualToInfo:(YHASCollectionLayoutInfo *)info{
    if (info == nil) {
        return NO;
    }
    return _numberOfColumns == info.numberOfColumns
    && _columnSpacing == info.columnSpacing
    && UIEdgeInsetsEqualToEdgeInsets(_sectionInsets, info.sectionInsets)
    && _interItemSpacing == info.interItemSpacing;
}

- (BOOL)isEqual:(id)other{
    if (self == other) {
        return YES;
    }
    if (! [other isKindOfClass:[YHASCollectionLayoutInfo class]]) {
        return NO;
    }
    return [self isEqualToInfo:other];
}

- (NSUInteger)hash{
    struct {
        NSInteger numberOfColumns;
        CGFloat columnSpacing;
        UIEdgeInsets sectionInsets;
        CGFloat interItemSpacing;
    } data = {
        _numberOfColumns,
        _columnSpacing,
        _sectionInsets,
        _interItemSpacing,
    };
    return ASHashBytes(&data, sizeof(data));
}


@end




@interface YHASCollectionLayoutDelegate()

@end


@implementation YHASCollectionLayoutDelegate {
    YHASCollectionLayoutInfo *_info;
    ASScrollDirection _scrollDirection;
}

- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                        scrollDirection:(ASScrollDirection)scrollDirection
{
    self = [super init];
    if (self) {
        _scrollDirection = scrollDirection;
        _info = [[YHASCollectionLayoutInfo alloc] initWithNumberOfColumns:numberOfColumns columnSpacing:columnSpacing interItemSpacing:interItemSpacing sectionInsets:sectionInsets];
    }
    return self;
}

#pragma mark ------------------ ASCollectionViewLayoutInspecting ------------------
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath{
    return ASSizeRangeZero;
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return ASSizeRangeZero;
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section{
    return 1;
}

#pragma mark ------------------ ASCollectionLayoutDelegate ------------------

- (ASScrollDirection)scrollableDirections{
    ASDisplayNodeAssertMainThread();
    return _scrollDirection;
}

- (id)additionalInfoForLayoutWithElements:(ASElementMap *)elements{
    ASDisplayNodeAssertMainThread();
    return _info;
}

// 真正布局的地方.
+ (ASCollectionLayoutState *)calculateLayoutWithContext:(ASCollectionLayoutContext *)context{
    CGFloat layoutWidth = context.viewportSize.width;
    ASElementMap *elements = context.elements;
    CGFloat top = 0;
    YHASCollectionLayoutInfo *info = (YHASCollectionLayoutInfo *)context.additionalInfo;
    
    NSMapTable<ASCollectionElement *, UICollectionViewLayoutAttributes *> *attrsMap = [NSMapTable elementToLayoutAttributesTable];
    NSMutableArray *columnHeights = [NSMutableArray array];
    
    NSInteger numberOfSections = [elements numberOfSections];
    
    // 遍历section.
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        
        NSInteger numberOfItems = [elements numberOfItemsInSection:section];
        
        top += info.sectionInsets.top;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        // header.
        ASCollectionElement *headerElement = [elements supplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (headerElement) {
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                     withIndexPath:indexPath];
            CGSize size = [headerElement.node layoutThatFits:ASSizeRangeUnconstrained].size;
            CGRect frame = CGRectMake(info.sectionInsets.left, top, size.width, size.height);
            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:headerElement];
            top = CGRectGetMaxY(frame);
        }
        
        //
        [columnHeights addObject:[NSMutableArray array]];
        for (NSUInteger idx = 0; idx < info.numberOfColumns; idx++) {
            [columnHeights[section] addObject:@(top)];
        }
        
    
        // item.
        CGFloat columnWidth = [self _columnWidthForSection:section withLayoutWidth:layoutWidth info:info];
        
        for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
            NSUInteger columnIndex = [self _shortestColumnIndexInSection:section withColumnHeights:columnHeights];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            ASSizeRange sizeRange = [self _sizeRangeForItem:element.node atIndexPath:indexPath withLayoutWidth:layoutWidth info:info];
            CGSize size = [element.node layoutThatFits:sizeRange].size;
            CGPoint position = CGPointMake(info.sectionInsets.left + (columnWidth + info.columnSpacing) * columnIndex,
                                           [columnHeights[section][columnIndex] floatValue]);
            CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
            
            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:element];
            
            columnHeights[section][columnIndex] = @(CGRectGetMaxY(frame) + info.interItemSpacing);
        }
        
        NSUInteger columnIndex = [self _tallestColumnIndexInSection:section withColumnHeights:columnHeights];
        top = [columnHeights[section][columnIndex] floatValue] - info.interItemSpacing + info.sectionInsets.bottom;
        
        
        // footer.
        ASCollectionElement *footerElement = [elements supplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        if (footerElement) {
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
            CGSize size = [footerElement.node layoutThatFits:ASSizeRangeUnconstrained].size;
            CGRect frame = CGRectMake(info.sectionInsets.left, top, size.width, size.height);
            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:footerElement];
            top = CGRectGetMaxY(frame);
        }
        
        //
        for (NSUInteger idx = 0; idx < [columnHeights[section] count]; idx++) {
            columnHeights[section][idx] = @(top);
        }
    }
    
    CGFloat contentHeight = [[[columnHeights lastObject] firstObject] floatValue];
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight);
    return [[ASCollectionLayoutState alloc] initWithContext:context contentSize:contentSize elementToLayoutAttributesTable:attrsMap];
}



+ (CGFloat)_columnWidthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(YHASCollectionLayoutInfo *)info{
    return ([self _widthForSection:section withLayoutWidth:layoutWidth info:info] - ((info.numberOfColumns - 1) * info.columnSpacing)) / info.numberOfColumns;
}

+ (CGFloat)_widthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(YHASCollectionLayoutInfo *)info{
    return layoutWidth - info.sectionInsets.left - info.sectionInsets.right;
}

+ (NSUInteger)_shortestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue < shortestHeight) {
            index = idx;
            shortestHeight = height.floatValue;
        }
    }];
    return index;
}

+ (ASSizeRange)_sizeRangeForItem:(ASCellNode *)item atIndexPath:(NSIndexPath *)indexPath withLayoutWidth:(CGFloat)layoutWidth info:(YHASCollectionLayoutInfo *)info {
    CGFloat itemWidth = [self _columnWidthForSection:indexPath.section withLayoutWidth:layoutWidth info:info];
    return ASSizeRangeMake(CGSizeMake(itemWidth, 0), CGSizeMake(itemWidth, CGFLOAT_MAX));
}

+ (NSUInteger)_tallestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights{
    __block NSUInteger index = 0;
    __block CGFloat tallestHeight = 0;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue > tallestHeight) {
            index = idx;
            tallestHeight = height.floatValue;
        }
    }];
    return index;
}

@end
