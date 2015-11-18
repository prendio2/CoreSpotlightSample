//
//  ViewController.m
//  CoreSpotlightSample
//
//  Created by Oisin Prendiville on 23/10/2015.
//  Copyright © 2015 Oisin Prendiville. All rights reserved.
//

@import CoreSpotlight;
#import <MobileCoreServices/MobileCoreServices.h>

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSURL *artworkURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *artworkPath = [self artworkURL].path;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:artworkPath];
    if (!fileExists) {
        BOOL written = [UIImagePNGRepresentation([UIImage imageNamed:@"artwork"]) writeToFile:artworkPath atomically:YES];
        if (written) {
            NSLog(@"saved artowrk at path %@",artworkPath);
        } else {
            NSLog(@"failed to write artwork");
        }
    } else {
        NSLog(@"artwork exists at path %@",artworkPath);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearIndexButtonTapped:(id)sender {
    [self resetIndexAnd:nil];
}

- (IBAction)createIndexButtonTapped:(id)sender {
    [self resetIndexAnd:^{
        [self createIndex];
    }];
}

- (NSURL *)artworkURL {
    if (!_artworkURL) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"artwork.png"];
        _artworkURL = [NSURL fileURLWithPath:filePath];
    }
    return _artworkURL;
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
    NSLog(@"indexing episodes with artwork URL: %@",self.artworkURL);
    for (NSUInteger i = 1; i < 100; i++) {
        [self addEpisodeToIndexWithEpisodeNumber:@(i)];
    }
}

- (void)addEpisodeToIndexWithEpisodeNumber:(NSNumber *)episodeNumber
{
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeAudiovisualContent];
    
    attributes.title = [NSString stringWithFormat:@"Sample Podcast: Episode %@", episodeNumber];
    attributes.contentDescription = [NSString stringWithFormat:@"Episode %@ of this fictional sample podcast", episodeNumber];
    attributes.thumbnailURL = self.artworkURL;
    
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
