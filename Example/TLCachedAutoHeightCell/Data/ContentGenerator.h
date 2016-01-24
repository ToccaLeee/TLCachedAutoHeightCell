//
//  ContentGenerator.h
//
//  Created by ToccaLee on 23/1/2016.
//  Copyright © 2016 ToccaLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ContentGenerator : NSObject

+ (nonnull NSArray<Model *> *)testModelWithCount:(NSUInteger)count;

@end
