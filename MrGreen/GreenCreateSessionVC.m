//
//  GreenCreateSessionVC.m
//  MrGreen
//
//  Created by Michael Zhao on 6/20/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "GreenCreateSessionVC.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface GreenCreateSessionVC () <MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UITextView *textBox;
@property (nonatomic, strong) UITextField *chatBox;

@end

@implementation GreenCreateSessionVC

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
    [self setUpUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpUI{
    //  Setup the browse button
    self.browserButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browserButton setTitle:@"Browse" forState:UIControlStateNormal];
    self.browserButton.frame = CGRectMake(130, 500, 60, 30);
    [self.view addSubview:self.browserButton];
    
    //  Setup TextBox
    self.textBox = [[UITextView alloc] initWithFrame: CGRectMake(40, 180, 240, 270)];
    self.textBox.editable = NO;
    self.textBox.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.textBox];
    
    //  Setup ChatBox
    self.chatBox = [[UITextField alloc] initWithFrame: CGRectMake(40, 80, 240, 70)];
    self.chatBox.backgroundColor = [UIColor lightGrayColor];
    self.chatBox.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.chatBox];
}

@end
