//
//  ViewController.m
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

#import "TemperatureViewController.h"
#import "theThingsIOWrapper.h"
#import "Account.h"
#import "AppDelegate.h"

@interface TemperatureViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelForTemperature;
@property (weak, nonatomic) IBOutlet UIButton *linkDeviceButton;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation TemperatureViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Temperature controller"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

#pragma mark - Button actions

- (IBAction)stepperChanged:(UIStepper *)sender {
    [self updateTemperature:[sender value]];
}

- (IBAction)logOut:(id)sender {
    // Delete all session data and show login view
    [[Account sharedInstance] logout];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showLoginViewControllerAnimated:YES];
}

// Link device with a hardcoded thing token (You should substitute the thing token for the thing token you want to add to user)
- (void)linkWithDevice {
    [[theThingsIOWrapper sharedInstance] linkDeviceWithDeviceToken:kThingToken withCompletion:^(id data, NSError *error) {
        if (!error){
            [self reloadData];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"Error with login" message:[error userInfo][@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self linkWithDevice];
}

#pragma mark - Private Methods

- (void)reloadData{
    [[theThingsIOWrapper sharedInstance] getDataWithCompletion:^(NSDictionary *result, NSError *error) {
        if (!error){
            NSNumber *value = [result[kThingID][0] valueForKey:@"value"];
            [self.labelForTemperature setText:[value stringValue]];
            [self.stepper setValue:[value doubleValue]];
            [self.linkDeviceButton setHidden:YES];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"No devices found" message:@"Welcome to theThings.io. You have no devices paired to your account. Pair a device now!" delegate:self cancelButtonTitle:@"Pair now" otherButtonTitles:nil, nil] show];
            [self.linkDeviceButton setHidden:NO];
        }
    }];
}

- (NSInteger)getTemperature {
    NSUInteger temperature = 0;
    if (![self.labelForTemperature.text isEqualToString:@"--"]){
        temperature = [self.labelForTemperature.text intValue];
    }
    return temperature;
}

- (void)updateTemperature:(NSInteger)temperature {
    [[theThingsIOWrapper sharedInstance] sendData:@(temperature)
                                          toThing:kThingID
                                   withCompletion:^(id data, NSError *error) {
                                       if (!error){
                                           [self reloadData];
                                       }
                                   }];
}

@end
