//
//  CustomFlowLayout.m
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout

-(NSArray*) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* answer = [super layoutAttributesForElementsInRect:rect];
    for (int i = 1; i < answer.count; i++) {
        UICollectionViewLayoutAttributes* currentAttributes = [answer objectAtIndex:i];
        UICollectionViewLayoutAttributes* previousAttributes = [answer objectAtIndex:i-1];
        CGFloat maxSpacing = 0.0;
        CGFloat origin = CGRectGetMaxX(previousAttributes.frame);
        if ((origin + maxSpacing + currentAttributes.frame.size.width) < self.collectionViewContentSize.width) {
            CGRect frame = currentAttributes.frame;
            frame.origin.x = origin + maxSpacing;
            currentAttributes.frame = frame;
        }
    }
    return answer;
}

@end
