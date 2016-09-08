//
//  OVUser.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/15/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVUser.h"

@implementation OVUser

- (id)initWithServeResponse:(NSDictionary *)responseObject {
    self = [super init];
    
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.userId = [[responseObject objectForKey:@"user_id"] integerValue];

        NSString *urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }

    return self;
}

- (id)initWithDetailServeResponse:(NSDictionary *)responseObject {
    self = [super init];
    
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.userId = [[responseObject objectForKey:@"id"] integerValue];

        NSString *urlOrigString = [responseObject objectForKey:@"photo_200"];
        
        if (urlOrigString) {
            self.imageOrigURL = [NSURL URLWithString:urlOrigString];
        }
        
        NSString *dateString = [responseObject objectForKey:@"bdate"];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSDate *nowDate = [NSDate date];
        
        if ([dateString length] > 5) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            NSString *dateFormat = @"dd.MM.YYYY";
                        
            [dateFormatter setDateFormat:dateFormat];
            
            NSDate *bDate = [dateFormatter dateFromString:dateString];
            
            dateComponents =
            [[NSCalendar currentCalendar]
             components:NSCalendarUnitYear
             fromDate:bDate
             toDate:nowDate
             options:0];
            
            self.age = [dateComponents year];
        }
        
        self.canWriteTo = [[responseObject objectForKey:@"can_write_private_message"] boolValue];
        
        NSDictionary *cityDict = [responseObject objectForKey:@"city"];
        self.city = [cityDict objectForKey:@"title"];
        
        self.isOnline = [[responseObject objectForKey:@"online"] boolValue];
        
        NSDictionary *lastSeenDict = [responseObject objectForKey:@"last_seen"];

        int timeIntervalSince1970 = [[lastSeenDict objectForKey:@"time"] intValue];

        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeIntervalSince1970];
        
        dateComponents =
        [[NSCalendar currentCalendar]
         components:NSCalendarUnitDay
         fromDate:lastDate
         toDate:nowDate
         options:0];
        
        self.lastSeen = [dateComponents day];
    }
    
    if ([[responseObject objectForKey:@"has_mobile"] boolValue]) {
        self.phoneNumber = [responseObject objectForKey:@"mobile_phone"];
    }
    
    self.followersCount = [[responseObject objectForKey:@"followers_count"] integerValue];
    
    self.homeTown = [responseObject objectForKey:@"home_town"];
    
    NSDictionary *countryDict = [responseObject objectForKey:@"country"];
    self.country = [countryDict objectForKey:@"title"];
    
    self.twitterId = [responseObject objectForKey:@"twitter"];
    self.site = [responseObject objectForKey:@"site"];

    self.about = [responseObject objectForKey:@"about"];
    self.interests = [responseObject objectForKey:@"interests"];
    self.activities = [responseObject objectForKey:@"activities"];
    self.music = [responseObject objectForKey:@"music"];
    self.movies = [responseObject objectForKey:@"movies"];
    self.tv = [responseObject objectForKey:@"tv"];
    self.books = [responseObject objectForKey:@"books"];
    self.quotes = [responseObject objectForKey:@"quotes"];

    return self;
}

@end