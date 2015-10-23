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

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    [self resetIndex];
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
}


- (void)resetIndex
{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Removed everything from index");
            
            [self createIndex];
            
        } else {
            NSLog(@"Failed to remove from index with error %@",error);
        }
    }];
}

- (void)createIndex
{
    [self addPodcastToIndex];
}

- (void)addPodcastToIndex
{
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    attributes.title = @"Sample Podcast";
    attributes.contentDescription = @"A Sample Podcast used to illustrate this CoreSpotlight issue";
    attributes.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"artwork"]);
    
    NSString *identifier = @"co.supertop.podcast.sample";
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier
                                                               domainIdentifier:@"co.supertop.podcast"
                                                                   attributeSet:attributes];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Added Sample Podcast to index");
        } else {
            NSLog(@"Failed to index Sample Podcast with error %@", error);
        }
    }];
    
    for (NSUInteger i = 1; i < 100; i++) {
        [self addEpisodeToIndexWithEpisodeNumber:i];
    }
}

- (void)addEpisodeToIndexWithEpisodeNumber:(NSUInteger)episodeNumber
{
    NSString *episodeTitle = [NSString stringWithFormat:@"Sample Podcast: Episode %lu", episodeNumber];
    NSDate *episodeReleaseDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(episodeNumber * 604800)];
    
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeAudio];
    attributes.title = episodeTitle;
    attributes.contentDescription = [NSString stringWithFormat:@"[%@] Episode %lu of this fictional sample podcast", [self.dateFormatter stringFromDate:episodeReleaseDate], episodeNumber];
    attributes.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"artwork"]);
    attributes.metadataModificationDate = episodeReleaseDate;
    
    attributes.containerTitle = @"Sample Podcast";
    attributes.containerIdentifier = @"co.supertop.podcast.sample";
    attributes.containerOrder = @(episodeNumber);
    
    NSString *identifier = [NSString stringWithFormat:@"co.supertop.podcast.sample.episode.%lu",episodeNumber];
    NSString *domain = [NSString stringWithFormat:@"co.supertop.episode.podcast.sample.%lu",episodeNumber];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier
                                                               domainIdentifier:domain
                                                                   attributeSet:attributes];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Added %@ to index", episodeTitle);
        } else {
            NSLog(@"Failed to index %@ with error %@", episodeTitle, error);
        }
    }];
}

@end
