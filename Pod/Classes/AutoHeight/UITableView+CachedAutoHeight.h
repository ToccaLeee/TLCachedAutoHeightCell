//
//  UITableView+CachedAutoHeight.h
//
//  Created by ToccaLee on 25/10/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CachedAutoHeight)

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(nonnull NSString *)identifier
                                        indexPath:(nonnull NSIndexPath *)indexPath
                                    configuration:(void (^ _Nullable)(id _Nonnull cell))configuration;

- (CGFloat)TL_autoHeightForCellWithReuseIdentifer:(nonnull NSString *)identifier
                                        indexPath:(nonnull NSIndexPath *)indexPath
                                         modelKey:(nonnull id)modelKey
                         heightAffectedProperties:(nullable NSArray<id> *)properties
                                    configuration:(void (^ _Nullable)(id _Nonnull cell))configuration;

@end
