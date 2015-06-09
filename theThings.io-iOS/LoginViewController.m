//
//  LoginViewController.m
//  theThings.io-iOS
//
// Copyright (c) 2015 Lafosca (http://lafosca.cat/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LoginViewController.h"
#import "theThingsIOWrapper.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textFieldEmail becomeFirstResponder];

    [self addBottomBorderToView:self.textFieldEmail withColor:[UIColor colorWithWhite:0.8 alpha:1.0] andWidth:0.5f];
    [self addBottomBorderToView:self.textFieldPassword withColor:[UIColor colorWithWhite:0.8 alpha:1.0] andWidth:0.5f];
}

- (void)addBottomBorderToView:(UIView *)view withColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, view.frame.size.height - borderWidth, view.frame.size.width, borderWidth);
    [view.layer addSublayer:border];
}

- (IBAction)login:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    [[theThingsIOWrapper sharedInstance] loginWithEmail:email andPassword:password withCompletion:^(id data, NSError *error) {
        if (!error){
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate showTemperatureViewControllerAnimated:YES];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"Error with login" message:[error userInfo][@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (IBAction)signup:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    [[theThingsIOWrapper sharedInstance] signUpWithEmail:email password:password withCompletion:^(id data, NSError *error) {
        if (!error){
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate showTemperatureViewControllerAnimated:YES];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"Error with operation" message:[error userInfo][@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

@end
