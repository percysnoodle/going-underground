//
//  AppDelegate.m
//  Doggies
//
//  Created by Simon Booth on 31/05/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360AppDelegate.h"

#import "C360APIClient.h"

#import "C360DogsController.h"

@interface C360AppDelegate ()

@end

@implementation C360AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:3000"];
    NSString *dbFileName = @"store.db";
    
    C360APIClient *apiClient = [[C360APIClient alloc] initWithBaseURL:baseURL fileName:dbFileName];

    C360DogsController *dogsController = [[C360DogsController alloc] initWithAPIClient:apiClient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dogsController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor brownColor];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
