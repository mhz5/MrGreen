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
    [self saveFile];
    [self setUpUI];
    [self setUpMultipeer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveFile{
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
//    NSString *url = [NSString stringWithFormat:@"%@", urls[0]];
    NSString *content = @"Test content";
    NSString *destination = [[self applicationDocumentsDirectory].path
     stringByAppendingPathComponent:@"testFile.txt"];
    
    NSError *error = nil;
    BOOL succeeded = [content writeToFile:destination atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (succeeded)
        NSLog(@"Successfully saved a file at %@", destination);
    else
        NSLog(@"Failed to store. Error: %@", error);
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void) setUpUI{
    //  Setup the browse button
    self.browserButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browserButton setTitle:@"Browse" forState:UIControlStateNormal];
    self.browserButton.frame = CGRectMake(130, 500, 60, 30);
    [self.view addSubview:self.browserButton];
    [self.browserButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.chatBox.delegate = self;
}

- (void) setUpMultipeer{

    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
    
    self.browserVC.delegate = self;
    self.mySession.delegate = self;

}

- (void) showBrowserVC{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendText{
    //  Retrieve text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    
    //  Convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //  Send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    //  Append your own text to text box
    [self receiveMessage: message fromPeer: self.myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
    //  Create the final text to append
    NSString *finalText;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@\n", message];
    }
    else{
        finalText = [NSString stringWithFormat:@"\n%@: %@\n", peer.displayName, message];
    }
    
    //  Append text to text box
    self.textBox.text = [self.textBox.text stringByAppendingString:finalText];
}

#pragma marks UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

#pragma Session Delegate Methods

//Called when a peer connects to the user, or the users device connects to a peer.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}

// Called when the users device recieves data from a peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    //  Decode data back to NSString
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //  append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        [self receiveMessage: message fromPeer: peerID];
    });
}

// Called when the users device recieves a byte stream from a peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Called when the users device recieves a resource from a peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Called when the users device has finished recieving data from a peer.
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

@end
