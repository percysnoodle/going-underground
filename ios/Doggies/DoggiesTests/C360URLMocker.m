//
//  C360URLMocker.m
//
//  Created by Simon Booth on 15/01/2013.
//  Copyright (c) 2013 CRedit360. All rights reserved.
//

#import "C360URLMocker.h"

NSString * const C360URLMockerException = @"C360URLMockerException";

static NSBundle * C360URLMockerBundle = nil;
static NSMutableDictionary * C360URLMockerMocksByMethod = nil;

@implementation C360URLMocker

+ (void)setUpWithBundle:(NSBundle *)bundle
{
    C360URLMockerBundle = bundle;
    C360URLMockerMocksByMethod = [NSMutableDictionary dictionary];
    [NSURLProtocol registerClass:self];
}

+ (void)tearDown
{
    [NSURLProtocol unregisterClass:self];
    C360URLMockerBundle = nil;
    C360URLMockerMocksByMethod = nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([request.URL.host hasSuffix:@".apple.com"]) {
        return NO;
    }
    
    return YES;
}

+ (void)mockMethod:(NSString *)method path:(NSString *)path callback:(C360URLMockerCallback)callback
{
    NSMutableDictionary *mocksByMethod = [NSMutableDictionary dictionaryWithDictionary:C360URLMockerMocksByMethod[method]];
    NSMutableArray *mocksByPath = [NSMutableArray arrayWithArray:mocksByMethod[path]];
    
    [mocksByPath insertObject:[callback copy] atIndex:0];
    
    mocksByMethod[path] = mocksByPath;
    C360URLMockerMocksByMethod[method] = mocksByMethod;
}

+ (void)unmockMethod:(NSString *)method path:(NSString *)path
{
    NSMutableDictionary *mocks = C360URLMockerMocksByMethod[method];
    if (mocks)
    {
        [mocks removeObjectForKey:path];
        if (mocks.count == 0)
        {
            [C360URLMockerMocksByMethod removeObjectForKey:method];
        }
    }
}

- (void)serveMockResponseWithStatusCode:(NSInteger)statusCode fileName:(NSString *)fileName forRequest:(NSURLRequest *)request
{
    NSLog(@"Serving mock response %@ for %@", fileName, request.URL);
    
    NSString *mimeType = @"application/octet-stream";
    if ([fileName.pathExtension isEqual:@"html"]) mimeType = @"text/html";
    if ([fileName.pathExtension isEqual:@"json"]) mimeType = @"application/json";
    if ([fileName.pathExtension isEqual:@"xml"]) mimeType = @"text/xml";
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                              statusCode:statusCode
                                                             HTTPVersion:@"1.1"
                                                            headerFields:@{ @"Content-Type" : mimeType }];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    if (fileName)
    {
        NSURL *dataURL = [C360URLMockerBundle URLForResource:[fileName stringByDeletingPathExtension] withExtension:[fileName pathExtension]];
        if (!dataURL) [NSException raise:C360URLMockerException format:@"Could not find %@", fileName];
        
        NSData *data = [NSData dataWithContentsOfURL:dataURL];
        if (!data) [NSException raise:C360URLMockerException format:@"Could not find data for %@", fileName];
        
        [self.client URLProtocol:self didLoadData:data];
    }
    
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)serveMockResponseWithError:(NSError *)error forRequest:(NSURLRequest *)request
{
    NSLog(@"Serving mock error for %@", request.URL);
    
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)startLoading
{
    NSDictionary *mocksByMethod = C360URLMockerMocksByMethod[self.request.HTTPMethod];
    NSArray *mocksByPath = mocksByMethod[self.request.URL.path];
    
    BOOL calledBack = NO;
    for (C360URLMockerCallback callback in mocksByPath)
    {
        if (callback(self, self.request))
        {
            calledBack = YES;
            break;
        }
    }
    
    if (!calledBack)
    {
        NSLog(@"No mock specified for %@ %@", self.request.HTTPMethod, self.request.URL.path);
        [NSException raise:C360URLMockerException format:@"No mock specified for %@ %@", self.request.HTTPMethod, self.request.URL.path];
    }
}

- (void)stopLoading
{
    // do nothing
}

@end
