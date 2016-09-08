//
//  OVSubscription.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVSubscription.h"

@implementation OVSubscription

- (id)initWithServeResponse:(NSDictionary *)responseObject {
    self = [super init];
    
    if (self) {
        
        if ([[responseObject objectForKey:@"type"] isEqualToString:@"profile"]) {
            
            self.pageType = OVSubscriptionTypeUser;
            
            self.firstName = [responseObject objectForKey:@"first_name"];
            self.lastName = [responseObject objectForKey:@"last_name"];
            
        } else {
            
            self.pageType = OVSubscriptionTypeGroup;
            
            self.screenName = [responseObject objectForKey:@"name"];
        }

        NSString *urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }

    }

    return self;
}

@end
