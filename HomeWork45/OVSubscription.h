//
//  OVSubscription.h
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    OVSubscriptionTypeUser,
    OVSubscriptionTypeGroup
    
} OVSubscriptionType;

@interface OVSubscription : NSObject

@property (assign, nonatomic) OVSubscriptionType pageType;

@property (strong, nonatomic) NSURL *imageURL;

@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;


- (id)initWithServeResponse:(NSDictionary *)responseObject;

@end
