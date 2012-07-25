//
//  NLInfoViewController.m
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import "NLInfoViewController.h"
#import "UIView+Layout.h"
#import "NSString+HexColor.h"

@interface NLInfoViewController ()

@end

@implementation NLInfoViewController
#pragma mark - Private
- (void)cancelPressed:(UIButton*)button {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)savePressed:(UIButton*)button {
    
    
    if ([_firstTextField.text rangeOfString:@"0x"].location == NSNotFound ||
        [_secondTextField.text rangeOfString:@"0x"].location == NSNotFound ||
        _firstTextField.text.length != 10 || _secondTextField.text.length != 10) {
        
        //NSLog(@"%@ (%d), %@ (%d)", _firstTextField.text, _firstTextField.text.length, _secondTextField.text, _secondTextField.text.length);
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please check the hex format\n(8 digits)" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    } else {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:_firstTextField.text forKey:@"first"];
        [defaults setObject:_secondTextField.text forKey:@"second"];
        
        [defaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];   
    }
}

#pragma mark - Public
- (id)init {
    
    if ((self = [super init])){
        
        _allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890abcdefABCDEF"];
        [_allowedCharacterSet retain];
    }
    
    return self;
}

- (void)dealloc {
    
    [_allowedCharacterSet release]; _allowedCharacterSet = nil;
    [_firstTextField release]; _firstTextField = nil;
    [_secondTextField release]; _secondTextField = nil;
    
    [super dealloc];
}

#pragma mark - UIViewController
- (void)loadView {

    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
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

    UIImage* firstTextFieldBackground = [UIImage imageNamed:@"input1.png"];
    UIImageView* firstTextFieldContainer = [[UIImageView alloc] initWithFrame:CGRectMake(floorf((self.view.width - firstTextFieldBackground.size.width) / 2),
                                                                                         logoView.bottom + 15.0f,
                                                                                         firstTextFieldBackground.size.width,
                                                                                         firstTextFieldBackground.size.height)];
    firstTextFieldContainer.userInteractionEnabled = YES;
    firstTextFieldContainer.image = firstTextFieldBackground;
    
    [self.view addSubview:firstTextFieldContainer];
    
    _firstTextField = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, floorf((firstTextFieldContainer.height - 16.0f) / 2), 
                                                                    220.0f, 16.0f)];
    _firstTextField.textColor = [@"#444444" colorFromHex];
    _firstTextField.font = [UIFont boldSystemFontOfSize:14.0f];
    _firstTextField.delegate = self;
    _firstTextField.returnKeyType = UIReturnKeyDone;
    
    [firstTextFieldContainer addSubview:_firstTextField];    
    [firstTextFieldContainer release];
    
    UIImage* secondTextFieldBackground = [UIImage imageNamed:@"input2.png"];
    UIImageView* secondTextFieldContainer = [[UIImageView alloc] initWithFrame:CGRectMake(floorf((self.view.width - secondTextFieldBackground.size.width) / 2),
                                                                                         firstTextFieldContainer.bottom + 10.0f,
                                                                                         secondTextFieldBackground.size.width,
                                                                                         secondTextFieldBackground.size.height)];
    secondTextFieldContainer.userInteractionEnabled = YES;
    secondTextFieldContainer.image = secondTextFieldBackground;
    
    
    [self.view addSubview:secondTextFieldContainer];
    
    _secondTextField = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, floorf((secondTextFieldContainer.height - 16.0f) / 2), 
                                                                     220.0f, 16.0f)];
    _secondTextField.textColor = [@"#444444" colorFromHex];
    _secondTextField.font = [UIFont boldSystemFontOfSize:14.0f];
    _secondTextField.delegate = self;
    _secondTextField.returnKeyType = UIReturnKeyDone;
    
    [secondTextFieldContainer addSubview:_secondTextField];    
    
    UILabel* instructions = [[UILabel alloc] initWithFrame:CGRectMake(floorf((self.view.width - 260.0f) / 2),
                                                                      secondTextFieldContainer.bottom + 10.0f, 
                                                                      260.0f, 35.0f)];
    instructions.textColor = [UIColor whiteColor];
    instructions.backgroundColor = [UIColor clearColor];
    instructions.font = [UIFont boldSystemFontOfSize:13.0f];
    instructions.shadowColor = [UIColor blackColor];
    instructions.shadowOffset = CGSizeMake(0, -1);
    instructions.text = @"Enter the 32bit HEX command for the buttons above";
    instructions.numberOfLines = 0;
    instructions.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:instructions];
    
    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
    [saveButton sizeToFit];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(24.0f, instructions.bottom + 18.0f, saveButton.width, saveButton.height);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    saveButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [self.view addSubview:saveButton];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    cancelButton.frame = CGRectMake(saveButton.right + 10.0f, saveButton.top, cancelButton.width, cancelButton.height);
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [self.view addSubview:cancelButton];
    
    [secondTextFieldContainer release];
    
    [instructions release];
    [logoView release];
    [labIconView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* firstText = [[NSUserDefaults standardUserDefaults] stringForKey:@"first"];
    NSString* secondText = [[NSUserDefaults standardUserDefaults] stringForKey:@"second"];
    
    _firstTextField.text = firstText;
    _secondTextField.text = secondText;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_firstTextField release];
    [_secondTextField release];
    // Release any retained subviews of the main view.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Hex only
    if (string.length > 0 && [string rangeOfCharacterFromSet:_allowedCharacterSet].location == NSNotFound)
        return NO;

    // no pasting
    if (string.length > 1)
        return NO;
    
    NSString* newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // can not delete "0x"
    if (newText.length < 2)
        return NO;
    
    // limit length
    if (newText.length > 10)
        return NO;
    
    NSString* newHex = [newText substringFromIndex:2];
    newHex = [newHex uppercaseString];
    
    textField.text = [NSString stringWithFormat:@"0x%@", newHex];
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO;
}

@end
