//
//  OVPost.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVPost.h"

@implementation OVPost

- (id)initWithServeResponse:(NSDictionary *)responseObject {
    self = [super init];
    
    if (self) {
        
        self.postId = [[responseObject objectForKey:@"id"] integerValue];
        self.fromId = [[responseObject objectForKey:@"from_id"] integerValue];
        
        NSUInteger unixTimeDate = [[responseObject objectForKey:@"date"] integerValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:unixTimeDate];
        
        NSArray *attachsArray = [responseObject objectForKey:@"attachments"];
        
        NSMutableArray *attachments = [NSMutableArray array];
        
        for (NSDictionary *object in attachsArray) {
            
            NSString *photoURLstring = @"";
            
            NSString *photoKey = @"photo_604";
            
            if ([[object objectForKey:@"type"] isEqualToString:@"photo"]) {
                NSDictionary *photo = [object objectForKey:@"photo"];
                
                photoURLstring = [photo objectForKey:photoKey];
                
            } else if ([[object objectForKey:@"type"] isEqualToString:@"video"]) {
                NSDictionary *video = [object objectForKey:@"video"];
                
                photoURLstring = [video objectForKey:photoKey];

            } else if ([[object objectForKey:@"type"] isEqualToString:@"link"]) {
                NSDictionary *link = [object objectForKey:@"link"];
                
                photoURLstring = [link objectForKey:photoKey];

            } else if ([[object objectForKey:@"type"] isEqualToString:@"page"]) {
                NSDictionary *page = [object objectForKey:@"page"];
                
                photoURLstring = [page objectForKey:photoKey];

            }
            
            if ([photoURLstring length] > 0) {
                
                [attachments addObject:[NSURL URLWithString:photoURLstring]];

            }
            
        }
        
        self.attachmentsImagesURLs = [NSArray arrayWithArray:attachments];
        
        NSDictionary *commentsDict = [responseObject objectForKey:@"comments"];
        self.commentsCounter = [[commentsDict objectForKey:@"count"] integerValue];
        
        NSDictionary *likesDict = [responseObject objectForKey:@"likes"];
        self.likesCounter = [[likesDict objectForKey:@"count"] integerValue];
        
        NSDictionary *repostsDict = [responseObject objectForKey:@"reposts"];
        self.repostsCounter = [[repostsDict objectForKey:@"count"] integerValue];
        
        self.text = [responseObject objectForKey:@"text"];
        
        self.postType = [responseObject objectForKey:@"post_type"];
    }
    
    return self;
}

@end
