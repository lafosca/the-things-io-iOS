//
//  Account.m
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

#import "Account.h"

@interface Account()

@property (nonatomic, strong) VALValet *valet;

@end

@implementation Account

+ (instancetype)sharedInstance {
    static Account *_sharedInstance = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[Account alloc] init];
        _sharedInstance.valet = [[VALValet alloc] initWithIdentifier:@"thingsIO" accessibility:VALAccessibilityWhenUnlocked];
    });
    
    return _sharedInstance;
}

-(void)setSessionToken:(NSString *)sessionToken {
    [self.valet setString:sessionToken forKey:@"session_token"];
}

-(NSString *)sessionToken {
    return [self.valet stringForKey:@"session_token"];
}

- (void)logout {
    [self.valet removeObjectForKey:@"session_token"];
}

@end
