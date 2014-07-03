//
//  GreenRequestFile.m
//  MrGreen
//
//  Created by Warren Green(Online Monetization) on 6/20/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "GreenRequestFile.h"

@interface GreenRequestFile ()

@end

@implementation GreenRequestFile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadFile:(id)sender {
    NSString *urlString = @"http://scienceblogs.com/gregladen/files/2012/12/Beautifull-cat-cats-14749885-1600-1200.jpg";
    NSURL *url = [[NSURL alloc] initWithString:@"http://robotic-pact-617.appspot.com/getFile"];
    NSString *post = [NSString stringWithFormat:@"&fileUrl=%@", urlString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSString *url;[data getBytes:*url];
    NSLog(@"tits");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ugh");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"dope");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
