//
//  OVWallTableViewController.m
//  HomeWork45
//
//  Created by Oleh Veheria on 7/17/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVPost.h"
#import "OVServerManager.h"
#import "OVUser.h"
#import "OVWallTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface OVWallTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *postsArray;
@property (assign, nonatomic) BOOL isDownloading;

@end

typedef enum : NSUInteger {
    OVRowContentNameSender  = 0,
    OVRowContentNamePhoto   = 1,
    OVRowContentNameText    = 2
    
} OVRowContentName;

@implementation OVWallTableViewController

static NSInteger postsInRequest = 15;
static NSInteger contentBottomInset = 70;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postsArray = [NSMutableArray array];
        
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, contentBottomInset, 0);
    
    [self getPostsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)getPostsFromServer {

    self.isDownloading = YES;
        
    NSLog(@"isDownloading = YES");

    
    [[OVServerManager sharedManager]
     getPostsArrayWithUserID:[self.user userId]
     count:postsInRequest
     offset:[self.postsArray count]
     onSuccess:^(NSArray *posts, NSString *errorString) {
         
         if (errorString) {
             
             [self showErrorStringMessage:errorString];
             
         } else {
             
             [self.postsArray addObjectsFromArray:posts];
             
             NSMutableArray *newPaths = [NSMutableArray array];
             
             for (int i = (int)[self.postsArray count] - (int)[posts count]; i < [self.postsArray count]; i++) {
                 
                 [newPaths addObject:[NSIndexPath indexPathForItem:0 inSection:i]];
                 [newPaths addObject:[NSIndexPath indexPathForItem:1 inSection:i]];
                 [newPaths addObject:[NSIndexPath indexPathForItem:2 inSection:i]];
             }
             
             [self.tableView beginUpdates];
             
             [self.tableView
              insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(([self.postsArray count] - [posts count]), [posts count])] withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationNone];
             
             [self.tableView endUpdates];
             
             NSLog(@"isDownloading = NO");
             
             self.isDownloading = NO;
             
             
         }
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
     }];
    
}

#pragma mark - Animation

- (void)animateCell:(UITableViewCell *)cell {
    
    [self.tableView.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         
                         cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             NSLog(@"FINISHED ANIMATING");
                             
                         }
                     }];
    
}

#pragma mark - Private Methods

- (void)showErrorStringMessage:(NSString *)errorString {
    
    [self.tableView.layer removeAllAnimations];
    
    CGRect labelRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) / 2, 80);
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:labelRect];
    
    errorLabel.center = self.view.center;
    errorLabel.numberOfLines = 4;
    
    errorLabel.text = errorString;
    errorLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    
    [errorLabel sizeToFit];
    
    [self.view addSubview:errorLabel];
    [self.view bringSubviewToFront:errorLabel];
    
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)newWidth {
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = newWidth / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.postsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    OVPost *post = [self.postsArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == OVRowContentNameSender) {
        
        static NSString *identifier = @"SenderCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];
        }

        if (!post.sender) {
                        
            [[OVServerManager sharedManager]
             getUserInfoWithID:post.fromId
             onSuccess:^(OVUser *user) {
                 
                 post.sender = user;
                 
                 cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];

                 
             } onFailure:^(NSError *error, NSInteger statusCode) {
                 
                 //[self showErrorStringMessage:error];
             }];

        } else {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", post.sender.firstName, post.sender.lastName];

        }
        
    } else if (indexPath.row == OVRowContentNamePhoto) {
        
        static NSString *identifier = @"PhotoCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
                        
        }
        
        
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:111];
        
        if (!post.image) {
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[post.attachmentsImagesURLs firstObject]];
            
            if (request) {
                
                __weak UITableViewCell *weakCell = cell;
                __weak UIImageView *weakImageView = imageView;
                
                imageView.image = nil;
                
                [weakCell.imageView
                 setImageWithURLRequest:request
                 placeholderImage:nil
                 success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                     
                     UIImage *scaledImage = [OVWallTableViewController imageWithImage:image scaledToWidth:self.tableView.bounds.size.width];
                     
                     post.image = scaledImage;
                                          
                     weakImageView.image = scaledImage;
                                          
                     //[weakCell setNeedsLayout];
                     
                     [tableView beginUpdates];
                     [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                     [tableView endUpdates];
                     
                 } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                     
                 }];
            }
            
        } else {
            
            imageView.image = post.image;
        }

        
    } else if (indexPath.row == OVRowContentNameText) {
        
        static NSString *identifier = @"TextCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        cell.textLabel.numberOfLines = 0;

        cell.textLabel.text = post.text;
        
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource
/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    headerView.backgroundColor = [UIColor colorWithRed:235 green:235 blue:241 alpha:1];
    
    return headerView;
}
*/
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    OVPost *post = [self.postsArray objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    
    NSString *date = [dateFormatter stringFromDate:post.date];
        
    return date;

}
/*
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    footerView.backgroundColor = [UIColor colorWithRed:235 green:235 blue:241 alpha:1];
    
    return footerView;

}
*/
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    OVPost *post = [self.postsArray objectAtIndex:section];
    
    NSString *string = @"";
    
    if (post.likesCounter > 0) {
        string = [NSString stringWithFormat:@"LIKES %ld ", post.likesCounter];
        
    }
    
    if (post.commentsCounter > 0) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"COMMENTS %ld ", post.commentsCounter]];

    }
    
    if (post.repostsCounter > 0) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"REPOSTS %ld", post.repostsCounter]];

    }
    
    return string;

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*OVPost *post = [self.postsArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == OVRowContentNamePhoto && post.image) {
        return post.image.size.height;
    }
    */
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OVPost *post = [self.postsArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == OVRowContentNamePhoto && !post.image) {
        return post.image.size.height;
    }
    
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == [self.postsArray count] - 1 && !self.isDownloading) {
        
        [self getPostsFromServer];
        
        NSLog(@"LOADING");

    }
}

@end