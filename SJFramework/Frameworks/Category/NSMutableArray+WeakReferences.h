//
//  NSMutableArray+WeakReferences.h
//  FetionUtil
//
//  Created by Born on 14-3-17.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)
+ (id)noRetainingArray;
+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity;
+ (id)noRetainingArrayWithArray:(NSArray*)array;

@end


@interface NSMutableDictionary  (WeakReferences)
+ (id)noRetainingDictionary;
+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity;
@end