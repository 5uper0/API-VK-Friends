//
//  OVServerManager.h
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OVUser;

@interface OVServerManager : NSObject

@property (strong, nonatomic) UIImage *image;

+ (OVServerManager *)sharedManager;

- (void)getUserInfoWithID:(NSInteger)userId
                onSuccess:(void(^)(OVUser *user))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *friends))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getFollowersWithUserID:(NSInteger)userId
                         count:(NSInteger)count
                        offset:(NSInteger)offset
                     onSuccess:(void(^)(NSArray *followers))success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getPostsArrayWithUserID:(NSInteger)userId
                          count:(NSInteger)count
                         offset:(NSInteger)offset
                      onSuccess:(void(^)(NSArray *postsArray, NSString *errorString))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getSubscriptionsWithUserID:(NSInteger)userId
                             count:(NSInteger)count
                            offset:(NSInteger)offset
                         onSuccess:(void(^)(NSArray *subscriptions))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
