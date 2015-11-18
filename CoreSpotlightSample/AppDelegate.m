//
//  AppDelegate.m
//  CoreSpotlightSample
//
//  Created by Oisin Prendiville on 23/10/2015.
//  Copyright © 2015 Oisin Prendiville. All rights reserved.
//

@import CoreSpotlight;
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self resetIndexAnd:^{
        [self createIndex];
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self resetIndexAnd:nil];
}


- (void)resetIndexAnd:(void (^)(void))thenBlock
{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Removed everything from index");
            if (thenBlock != nil) {
                thenBlock();
            }
        } else {
            NSLog(@"Failed to remove from index with error %@",error);
        }
    }];
}

- (void)createIndex
{
    for (NSUInteger i = 1; i < 10000; i++) {
        [self addEpisodeToIndexWithEpisodeNumber:@(i) thumbnailData:UIImagePNGRepresentation([UIImage imageNamed:@"artwork"])];
    }
}

- (void)addEpisodeToIndexWithEpisodeNumber:(NSNumber *)episodeNumber thumbnailData:(NSData *)thumbnailData
{
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeAudiovisualContent];
    
    attributes.title = [NSString stringWithFormat:@"Sample Podcast: Episode %@", episodeNumber];
    attributes.contentDescription = [NSString stringWithFormat:@"Episode %@ of this fictional sample podcast", episodeNumber];
    attributes.thumbnailData = thumbnailData;
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:nil domainIdentifier:nil attributeSet:attributes];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Added episode %@ to index", episodeNumber);
        } else {
            NSLog(@"Failed to index episode %@ with error %@", episodeNumber, error);
        }
    }];
}

@end
