//
//  Labyrinth.m
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "Labyrinth.h"

@implementation Labyrinth

@dynamic beginningCell;
@dynamic numOfCellsHorizontal;
@dynamic numOfCellsVertical;
@dynamic bordersEncoded;

-(void)loadWithSymbolsString:(NSString*)string {
    NSString* beginning = [string substringWithRange:NSMakeRange(0, 2)];
    self.beginningCell = [NSNumber numberWithInt:[beginning intValue]];
    NSLog(@"beginning %@", self.beginningCell);
    
    NSString* cellsHorizontal = [string substringWithRange:NSMakeRange(2, 1)];
    self.numOfCellsHorizontal = [NSNumber numberWithInt:[cellsHorizontal intValue]];
    NSLog(@"horizontal %@", self.numOfCellsHorizontal);
    
    NSString* cellsVertical = [string substringWithRange:NSMakeRange(3, 1)];
    self.numOfCellsVertical = [NSNumber numberWithInt:[cellsVertical intValue]];
    NSLog(@"vertical %@", self.numOfCellsVertical);
    
    NSString* encodedBorders = [string substringFromIndex:4];
    NSArray* bordersArray = [self bordersArrayWithString:encodedBorders];
    self.bordersEncoded = bordersArray;
    NSLog(@"borders %@", self.bordersEncoded);

}

-(NSArray*)bordersArrayWithString:(NSString*)borders {
    NSLog(@"bordersString %@", borders);
    NSMutableArray* bordersArray = [[NSMutableArray alloc] init];
    int numOfCells = self.numOfCellsHorizontal.intValue * self.numOfCellsVertical.intValue;
    for (int i = 0; i < numOfCells; i++) {
        int startIndex = i * 4;
        NSLog(@"start index now %d", startIndex);
        NSString* cellBorders = [borders substringWithRange:NSMakeRange(startIndex, 4)];
        NSMutableArray* bArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < 4; j++) {
            NSString* boolBorderString = [cellBorders substringWithRange:NSMakeRange(j, 1)];
            int boolBorder = boolBorderString.intValue;
            NSNumber* numberForArray = [NSNumber numberWithInt:boolBorder];
            [bArray addObject:numberForArray];
            NSLog(@"bArray for cell %d %@ ", i,bArray);
        }
        [bordersArray addObject:bArray];
    }
    NSLog(@"Created bordersArray: %@", bordersArray);
    return bordersArray;
}


@end
