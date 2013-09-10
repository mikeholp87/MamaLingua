//
//  DataGenerator.m
//  MamaLingua
//
//  Created by Mike Holp on 2/21/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import "DataGenerator.h"

@implementation DataGenerator

#define WORD_LENGTH 5

static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";

+ (NSArray *) wordsFromLetters {
    NSMutableArray *content = [NSMutableArray new];
    NSMutableDictionary *alphabet = [NSMutableDictionary new];
    
    for (int i = 0; i < [letters length]; i++ ) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        char currentWord[WORD_LENGTH + 1];
        NSMutableArray *words = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < WORD_LENGTH; j++ ) {
            if (j == 0) {
                currentWord[j] = toupper([letters characterAtIndex:i]);
            }
            else {
                currentWord[j] = [letters characterAtIndex:i];
            }
            currentWord[j+1] = '\0';
            [words addObject:[NSString stringWithCString:currentWord encoding:NSASCIIStringEncoding]];
        }
        char currentLetter[2] = { toupper([letters characterAtIndex:i]), '\0'};
        [row setValue:[NSString stringWithFormat:@"%s", currentLetter] forKey:@"alphabet"];
        [row setValue:[NSString stringWithCString:currentLetter encoding:NSASCIIStringEncoding]
               forKey:@"headerTitle"];
        [row setValue:words forKey:@"rowValues"];
        [content addObject:row];
    }
    
    return content;
}

@end
