//
//  OVPost.h
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OVUser;

@interface OVPost : NSObject

@property (assign, nonatomic) NSInteger postId;
@property (assign, nonatomic) NSInteger fromId;



@property (strong, nonatomic) OVUser *sender;
@property (strong, nonatomic) NSArray *images;

@property (strong, nonatomic) UIImage *image;


@property (strong, nonatomic) NSDate *date;

@property (assign, nonatomic) NSUInteger commentsCounter;
@property (assign, nonatomic) NSUInteger likesCounter;
@property (assign, nonatomic) NSUInteger repostsCounter;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *postType;

@property (strong, nonatomic) NSArray *attachmentsImagesURLs;


@property (strong, nonatomic) NSString *errorString;

- (id)initWithServeResponse:(NSDictionary *)responseObject;

@end