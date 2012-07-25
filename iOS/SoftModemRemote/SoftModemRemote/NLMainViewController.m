//
//  NLViewController.m
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import "NLMainViewController.h"
#import "UIView+Layout.h"
#import "NSString+HexColor.h"
#import "FSKSerialGenerator.h"
#import "NLInfoViewController.h"

@interface NSString (NSStringHexToBytes)
-(NSData*) hexToBytes ;
@end



@implementation NSString (NSStringHexToBytes)
-(NSData*) hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end


@interface NLMainViewController ()

@end

@implementation NLMainViewController

#pragma mark - Private
- (void)buttonPressed:(UIButton*)button {
    
    NSString* buttonKey = (button.tag == 1) ? @"first" : @"second";
    NSString* hex = [[NSUserDefaults standardUserDefaults] stringForKey:buttonKey];
    hex = [hex substringFromIndex:2];
    NSData* hexData = [hex hexToBytes];
    //NSLog(@"%@", hex);
    //NSLog(@"%@", [hex hexToBytes]);
    
	[APP_DELEGATE.generator writeByte:0xff];
    [APP_DELEGATE.generator writeBytes:[hexData bytes] length:hexData.length];
}

- (void)infoButtonPressed:(UIButton*)button {
    
    NLInfoViewController* infoController = [[NLInfoViewController alloc] init];
    infoController.modalPresentationStyle = UIModalPresentationFullScreen;
    infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:infoController animated:YES];
    [infoController release];
}

#pragma mark - UIViewController
- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [@"FBB03B" colorFromHex];
    
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    UIImageView* logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(floorf((self.view.width - logoView.width) / 2), 
                                24.0f, 
                                logoView.width, 
                                logoView.height);
    [self.view addSubview:logoView];
    
    UIImage* labIcon = [UIImage imageNamed:@"9lab.png"];
    UIImageView* labIconView = [[UIImageView alloc] initWithImage:labIcon];
    labIconView.frame = CGRectMake(floorf((self.view.width - labIconView.width) / 2),
                                self.view.height - labIconView.height - 24.0f,
                                labIconView.width,
                                labIconView.height);
    [self.view addSubview:labIconView];
    
    UIImage* panel = [UIImage imageNamed:@"panel.png"];
    UIImageView* panelView = [[UIImageView alloc] initWithImage:panel];
    panelView.frame = CGRectMake(floorf((self.view.width - panelView.width) / 2),
                                 logoView.bottom + 18.0f,
                                 panelView.width,
                                 panelView.height);
    panelView.userInteractionEnabled = YES;
    [self.view addSubview:panelView];
    
    CGFloat halfPanelHeight = floorf(panelView.height / 2);
    
    UIButton* one = [UIButton buttonWithType:UIButtonTypeCustom];
    one.tag = 1;
    [one setImage:[UIImage imageNamed:@"arrow_1.png"] forState:UIControlStateNormal];
    [one sizeToFit];
    one.frame = CGRectMake(floorf((panelView.width - one.width) / 2),
                          floorf((halfPanelHeight - one.height) / 2),
                          one.width,
                          one.height);
    [one addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* two = [UIButton buttonWithType:UIButtonTypeCustom];
    two.tag = 2;
    [two setImage:[UIImage imageNamed:@"arrow_2.png"] forState:UIControlStateNormal];
    [two sizeToFit];
    two.frame = CGRectMake(floorf((panelView.width - two.width) / 2),
                            halfPanelHeight + floorf((halfPanelHeight - two.height) / 2),
                            two.width,
                            two.height);

    [two addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [panelView addSubview:one];
    [panelView addSubview:two];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = CGRectMake(self.view.width - button.width - 10.0f, 
                              self.view.height - button.height - 10.0f,
                              button.width,
                              button.height);
    [button addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [logoView release];
    [labIconView release];
    [panelView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
