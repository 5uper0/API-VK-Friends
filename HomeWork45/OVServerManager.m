//
//  OVServerManager.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "OVUser.h"
#import "OVServerManager.h"
#import "OVSubscription.h"
#import "OVPost.h"

@interface OVServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *requestSessionManager;

@end

@implementation OVServerManager

+ (OVServerManager *)sharedManager {
    
    static OVServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OVServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void)getFollowersWithUserID:(NSInteger)userId
                         count:(NSInteger)count
                        offset:(NSInteger)offset
                     onSuccess:(void(^)(NSArray *followers))success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSString *fields = @"photo_100";
    
    NSDictionary *parametrs =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(userId),     @"user_id",
     @(count),      @"count",
     @(offset),     @"offset",
     fields,        @"fields",
     @"nom",        @"name_case",
     @"en",         @"lang", nil];
    
    [self.requestSessionManager
     GET:@"https://api.vk.com/method/users.getFollowers"
     parameters:parametrs
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"JSON: %@\n", responseObject);
         
         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
         
         NSArray *itemsArray = [responseDict objectForKey:@"items"];
         
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         for (NSDictionary *dict in itemsArray) {
             OVUser *user = [[OVUser alloc] initWithServeResponse:dict];
             [objectsArray addObject:user];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             
             NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
             NSInteger statusCode = response.statusCode;
             failure(error, statusCode);
         }
     }];
}

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *friends))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
        
    NSDictionary *parametrs =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"5094704",    @"user_id",
     @"name",       @"order",
     @(count),      @"count",
     @(offset),     @"offset",
     @"photo_100",  @"fields",
     @"nom",        @"name_case",
     @"en",         @"lang", nil];
    
    [self.requestSessionManager
     GET:@"https://api.vk.com/method/friends.get"
     parameters:parametrs
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"JSON: %@\n", responseObject);
         
         NSArray *dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         for (NSDictionary *dict in dictsArray) {
             OVUser *user = [[OVUser alloc] initWithServeResponse:dict];
             [objectsArray addObject:user];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             
             NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
             NSInteger statusCode = response.statusCode;
             failure(error, statusCode);
         }
     }];
}

- (void)getSubscriptionsWithUserID:(NSInteger)userId
                             count:(NSInteger)count
                            offset:(NSInteger)offset
                         onSuccess:(void(^)(NSArray *subscriptions))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSString *fields = @"photo_100, type, screen_name, first_name, last_name";
    
    NSDictionary *parametrs =
    [NSDictionary
     dictionaryWithObjectsAndKeys:
     @(userId), @"user_id",
     @"1",      @"extended",
     @(offset), @"offset",
     @(count),  @"count",
     fields,    @"fields", nil];
    
    [self.requestSessionManager
     GET:@"https://api.vk.com/method/users.getSubscriptions"
     parameters:parametrs
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"JSON: %@\n", responseObject);
         
         NSArray *responseArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         for (NSDictionary *dict in responseArray) {
             OVSubscription *subscription = [[OVSubscription alloc] initWithServeResponse:dict];
             [objectsArray addObject:subscription];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             
             NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
             NSInteger statusCode = response.statusCode;
             failure(error, statusCode);
         }
     }];
}

- (void)getUserInfoWithID:(NSInteger)userId
                onSuccess:(void(^)(OVUser *user))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSString *fields = @"bdate, city, photo_200, online, site, "
                        "last_seen, can_write_private_message, "
                        "has_mobile, mobile_phone, followers_count, "
                        "interests, music, activities, movies, tv, "
                        "books, about, quotes, country, twitter, "
                        "home_town";
    
    NSDictionary *parametrs =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(userId),     @"user_ids",
     fields,        @"fields",
     @"nom",        @"name_case",
     @"en",         @"lang",
     @"5.52",       @"v", nil];
    
    [self.requestSessionManager
     GET:@"https://api.vk.com/method/users.get"
     parameters:parametrs
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"JSON: %@\n", responseObject);
         
         NSArray *dictsArray = [responseObject objectForKey:@"response"];
         
         OVUser *user = [[OVUser alloc] init];
         
         if ([dictsArray count] == 1) {
             user = [[OVUser alloc] initWithDetailServeResponse:[dictsArray firstObject]];
         } else {
             NSLog(@"OBJECTS MORE THAN 1");
         }
         
         if (success) {
             success(user);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             
             NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
             NSInteger statusCode = response.statusCode;
             failure(error, statusCode);
         }
     }];
}

- (void)getPostsArrayWithUserID:(NSInteger)userId
                          count:(NSInteger)count
                         offset:(NSInteger)offset
                      onSuccess:(void(^)(NSArray *postsArray, NSString *errorString))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *parametrs =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(userId),     @"owner_id",
     @(offset),     @"offset",
     @(count),      @"count",
     @"all",        @"filter",
     @"en",         @"lang",
     @"5.52",       @"v", nil];
    
    [self.requestSessionManager
     GET:@"https://api.vk.com/method/wall.get"
     parameters:parametrs
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"JSON: %@\n", responseObject);
         
         NSDictionary *errorDict = [responseObject objectForKey:@"error"];
         
         if (errorDict) {
             success(nil, [errorDict objectForKey:@"error_msg"]);
         }
         
         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
         
         NSArray *itemsArray = [responseDict objectForKey:@"items"];
         
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         for (NSDictionary *dict in itemsArray) {
             OVPost *post = [[OVPost alloc] initWithServeResponse:dict];
             [objectsArray addObject:post];
         }
         
         if (success) {
             success(objectsArray, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             
             NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
             NSInteger statusCode = response.statusCode;
             failure(error, statusCode);
         }
     }];
}

@end