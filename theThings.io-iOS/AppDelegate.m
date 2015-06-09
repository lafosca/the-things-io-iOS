//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "TemperatureViewController.h"
#import "Account.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[Account sharedInstance] sessionToken] != nil){
        [self showTemperatureViewControllerAnimated:NO];
    } else {
        [self showLoginViewControllerAnimated:NO];
    }
    
    return YES;
}

- (void)showLoginViewControllerAnimated:(BOOL)animated {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
    [self changeRootViewController:loginViewController animated:YES];
}

- (void)showTemperatureViewControllerAnimated:(BOOL)animated {
    TemperatureViewController *temperatureViewController = [[TemperatureViewController alloc] initWithNibName:NSStringFromClass([TemperatureViewController class]) bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:temperatureViewController];
    [self changeRootViewController:navigationController animated:animated];
}

- (void)changeRootViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated){
        [UIView transitionWithView:self.window
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.window.rootViewController = viewController;
                            [self.window makeKeyAndVisible];
                        } completion:^(BOOL finished) {
                            // Code to run after animation
                        }];
    } else {
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
}


@end
