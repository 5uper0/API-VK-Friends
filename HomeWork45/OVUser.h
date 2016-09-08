//
//  OVUser.h
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVUser : NSObject

@property (assign, nonatomic) NSInteger userId;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *homeTown;

@property (strong, nonatomic) NSString *twitterId;
@property (strong, nonatomic) NSString *site;

@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *interests;
@property (strong, nonatomic) NSString *activities;
@property (strong, nonatomic) NSString *music;
@property (strong, nonatomic) NSString *movies;
@property (strong, nonatomic) NSString *tv;
@property (strong, nonatomic) NSString *books;
@property (strong, nonatomic) NSString *quotes;

@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) NSInteger lastSeen;
@property (assign, nonatomic) NSInteger followersCount;

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *imageOrigURL;

@property (assign, nonatomic) BOOL canWriteTo;
@property (assign, nonatomic) BOOL isOnline;

- (id)initWithServeResponse:(NSDictionary *)responseObject;
- (id)initWithDetailServeResponse:(NSDictionary *)responseObject;

@end
