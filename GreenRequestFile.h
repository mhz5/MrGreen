//
//  GreenRequestFile.h
//  MrGreen
//
//  Created by Warren Green(Online Monetization) on 6/20/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenRequestFile : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
