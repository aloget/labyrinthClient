//
//  Labyrinth.h
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Labyrinth : NSManagedObject

@property (nonatomic, retain) NSNumber * beginningCell;
@property (nonatomic, retain) NSNumber * numOfCellsHorizontal;
@property (nonatomic, retain) NSNumber * numOfCellsVertical;
@property (nonatomic, retain) id bordersEncoded;

-(void)loadWithSymbolsString:(NSString*)string;

@end
