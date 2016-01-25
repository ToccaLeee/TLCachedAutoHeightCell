//
//  UITableView+CachedAutoHeight.h
//
//  Created by ToccaLee on 25/10/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CachedAutoHeight)

/**
 *  @brief Calculate cell height and cache by indexpath
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param indexPath The indexpath the cell at, will be used by position based height cache
 *
 *  @param completion Configuration block which config cell's model data
 *
 */

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(nonnull NSString *)identifier
                                        indexPath:(nonnull NSIndexPath *)indexPath
                                    configuration:(void (^ _Nullable)(id _Nonnull cell))configuration;



/**
 *  @brief Calculate cell height and cache by content
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param modelKey The cell's model data's primary key, will used by content based height cache
 *
 *  @param properties The properties that will affect cell's height, will be hashed and used for checking content's modification
 *
 *  @param completion Configuration block which config cell's model data
 *
 */

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(nonnull NSString *)identifier
                                         modelKey:(nonnull id)modelKey
                         heightAffectedProperties:(nullable NSArray<id> *)properties
                                    configuration:(void (^ _Nullable)(id _Nonnull cell))configuration;

@end
