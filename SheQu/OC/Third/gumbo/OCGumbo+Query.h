//  Copyright [2013] tracy.cpp@gmail.com (TracyYih)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "OCGumbo.h"

@class  OCQueryObject;
typedef OCQueryObject * (^OCGumboQueryBlockAS) (NSString *);
typedef NSString *      (^OCGumboQueryBlockSS) (NSString *);
typedef NSString *      (^OCGumboQueryBlockSV) (void);

@interface OCGumboNode (Query)

/**
 *  Query children elements from current node by selector.
 *
 */
@property (nonatomic, weak, readonly) OCGumboQueryBlockAS Query;


@property (nonatomic, weak, readonly) OCGumboQueryBlockSS attr;

/**
 *  Get the combined text contents of element.
 */
@property (nonatomic, weak, readonly) OCGumboQueryBlockSV text;

/**
 *  Get the raw contents of element.
 */
@property (nonatomic, weak, readonly) OCGumboQueryBlockSV html;

@end

#pragma mark -
typedef OCGumboNode *   (^NSArrayQueryBlockNV) (void);
typedef OCGumboNode *   (^NSArrayQueryBlockNI) (NSUInteger);
typedef BOOL            (^NSArrayQueryBlockBS) (NSString *);
typedef NSUInteger      (^NSArrayQueryBlockIN) (OCGumboNode *);
typedef OCQueryObject * (^NSArrayQueryBlockAS) (NSString *);
typedef OCQueryObject * (^NSArrayQueryBlockSA) (void);
typedef NSString *      (^NSArrayQueryBlockSV) (void);

@interface OCQueryObject : NSArray

/**
 *  Get the combined text contents of the collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockSV text;

/**
 *  Get the combined text array of element.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockSA textArray;

/**
 *  Get the first element of the current collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockNV first;

/**
 *  Get the last element of the current collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockNV last;


@property (nonatomic, weak, readonly) NSArrayQueryBlockNI get;

/**
 *  Check if any elements in the collection have the specified class.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockBS hasClass;


@property (nonatomic, weak, readonly) NSArrayQueryBlockIN index;


@property (nonatomic, weak, readonly) NSArrayQueryBlockAS find;


@property (nonatomic, weak, readonly) NSArrayQueryBlockAS children;


@property (nonatomic, weak, readonly) NSArrayQueryBlockAS parent;


@property (nonatomic, weak, readonly) NSArrayQueryBlockAS parents;

@end
