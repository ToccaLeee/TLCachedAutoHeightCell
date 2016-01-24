//
//  Model.h
//  TLCachedAutoHeightCell
//
//  Created by ToccaLee on 24/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, assign) NSUInteger modelId;
@property (nonatomic, copy, nonnull) NSString *title;
@property (nonatomic, copy, nonnull) NSString *content;
@property (nonatomic, copy, nonnull) NSString *fixedContent;

@end
