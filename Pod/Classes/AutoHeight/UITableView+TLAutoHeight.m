//
//  UITableView+TLAutoHeight.m
//
//  Created by ToccaLee on 10/10/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "UITableView+TLAutoHeight.h"
#import "TLAutoHeightMacroDefine.h"
#import "UITableViewCell+TLAutoHeight.h"
#import "TLTableViewCellCacheConstants.h"

static char *const kAutoHeightCellCacheKey      = "TLAutoHeightCellCacheKey";
static char *const kCellContentWidthCacheKey    = "TLCellContentWidthCacheKey";
static char *const kTableViewWidthKey           = "TLTableViewWidthKey";
static char *const kCellIsAutoHeightKey         = "TLCellIsAutoHeightKey";
static char *const kCellFixedHeightKey          = "TLCellFixedHeightKey";

@interface UITableViewCell (PrivateAutoHeight)

@property (nonatomic, assign) BOOL    isAutoHeight;
@property (nonatomic, assign) CGFloat fixHeight;

@end

@implementation UITableViewCell (PrivateAutoHeight)

TL_BOOL_ASSOCIATE(isAutoHeight, setIsAutoHeight, false, kCellIsAutoHeightKey)
TL_FLOAT_ASSOCIATE(fixHeight, setFixHeight, kAutoHeightCellHeightCacheAbsentValue, kCellFixedHeightKey)

@end

static NSUInteger const kCellAccessViewWidth[] = {
    [UITableViewCellAccessoryNone]                    = 0,
    [UITableViewCellAccessoryDisclosureIndicator]     = 34,
    [UITableViewCellAccessoryDetailDisclosureButton]  = 68,
    [UITableViewCellAccessoryCheckmark]               = 40,
    [UITableViewCellAccessoryDetailButton]            = 48,
};

typedef NSMutableDictionary<NSString *, UITableViewCell *> CellCache;
typedef NSMutableDictionary<NSString *, NSNumber *>  WidthCache;

@interface UITableView ()

@property (nonatomic, strong) CellCache  *autoHeightCellCache;
@property (nonatomic, strong) WidthCache *cellContentWidthCache;
@property (nonatomic, assign) CGFloat    tableViewWidth;

@end

@implementation UITableView (TLAutoHeight)

TL_OBJECT_ASSOCIATE(autoHeightCellCache, setAutoHeightCellCache, CellCache *, [CellCache new], kAutoHeightCellCacheKey)
TL_OBJECT_ASSOCIATE(cellContentWidthCache, setCellContentWidthCache, WidthCache *, [WidthCache new], kCellContentWidthCacheKey)
TL_FLOAT_ASSOCIATE(tableViewWidth, setTableViewWidth, [UIScreen mainScreen].bounds.size.width, kTableViewWidthKey)

- (CGFloat)cellContentWidthWithCell:(UITableViewCell *)cell identifer:(NSString *)identifer {
    NSParameterAssert(cell);
    NSParameterAssert(identifer);
    NSNumber *floatNumber = self.cellContentWidthCache[identifer];
    if (!floatNumber) {
        CGFloat contentWidth = cell.accessoryView ? (self.tableViewWidth - 16 - cell.accessoryView.frame.size.width) :
                                                     self.tableViewWidth - kCellAccessViewWidth[cell.accessoryType];
        self.cellContentWidthCache[identifer] = @(contentWidth);
        return contentWidth;
    }
    return floatNumber.floatValue;
}

- (UITableViewCell *)autoHeightTemplateCellWithIndentifer:(NSString *)identifier {
    NSParameterAssert(identifier);
    UITableViewCell *cell = self.autoHeightCellCache[identifier];
    if (!cell) {
        cell = [self dequeueReusableCellWithIdentifier:identifier];
        cell.isAutoHeight = YES;
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false;
        self.autoHeightCellCache[identifier] = cell;
    }
    return cell;
}

- (CGFloat)TL_autoHeightForCellWithIdentifer:(NSString *)identifer configuration:(void(^)(id cell))configuration {
    NSParameterAssert(identifer);
    UITableViewCell *tmpCell = [self autoHeightTemplateCellWithIndentifer:identifer];
    
    NSAssert(tmpCell, @"tmpCell is nil, check cell identifer is correct");
    
    [tmpCell prepareForReuse];
    
    if (tmpCell.TL_isFixedHeight && tmpCell.fixHeight != kAutoHeightCellHeightCacheAbsentValue) {
        return tmpCell.fixHeight;
    }
    
    if (configuration) {
        configuration(tmpCell);
    }
    
    CGSize fittingSize =  CGSizeZero;
    BOOL isAutoLayoutEnabled = !tmpCell.TL_isEnforceFrameLayout && (tmpCell.contentView.constraints.count > 0);
    
    if (isAutoLayoutEnabled) {
        NSLayoutConstraint *tempWidthConstraint =
        [NSLayoutConstraint constraintWithItem:tmpCell.contentView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:[self cellContentWidthWithCell:tmpCell identifer:identifer]];
        [tmpCell.contentView addConstraint:tempWidthConstraint];
        fittingSize = [tmpCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [tmpCell removeConstraint:tempWidthConstraint];
    } else {
        NSAssert([tmpCell respondsToSelector:@selector(sizeThatFits:)], @"Should overide \"sizeThatFits:\" method if use frame layout");
        fittingSize = [tmpCell sizeThatFits:CGSizeMake([self cellContentWidthWithCell:tmpCell identifer:identifer], 0)];
    }
    
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    if (tmpCell.TL_isFixedHeight) {
        tmpCell.fixHeight = fittingSize.height;
    }
    
    return fittingSize.height;
}

@end
