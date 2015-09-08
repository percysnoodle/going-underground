//
//  C360URLMocker.h
//
//  Created by Simon Booth on 15/01/2013.
//  Copyright (c) 2013 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class C360URLMocker;

extern NSString * const C360URLMockerException;

typedef BOOL(^C360URLMockerCallback)(C360URLMocker *mocker, NSURLRequest *request);

@interface C360URLMocker : NSURLProtocol

+ (void)setUpWithBundle:(NSBundle *)bundle;
+ (void)tearDown;

+ (void)mockMethod:(NSString *)method path:(NSString *)path callback:(C360URLMockerCallback)callback;
+ (void)unmockMethod:(NSString *)method path:(NSString *)path;

- (void)serveMockResponseWithStatusCode:(NSInteger)statusCode fileName:(NSString *)fileName forRequest:(NSURLRequest *)request;
- (void)serveMockResponseWithError:(NSError *)error forRequest:(NSURLRequest *)request;

@end
