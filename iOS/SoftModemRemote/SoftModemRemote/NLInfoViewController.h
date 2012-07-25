//
//  NLInfoViewController.h
//  IRRemote
//
//  Created by Bret Cheng on 24/7/12.
//  Copyright (c) 2012 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLInfoViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField* _firstTextField;
    UITextField* _secondTextField;
    
    NSCharacterSet* _allowedCharacterSet;
}

@end
