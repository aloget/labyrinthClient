//
//  GameViewController.m
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "GameViewController.h"
#import "UIViewController+ShowAlertView.h"


@interface GameViewController () {
    NSString* winImage;
    int currentPosition;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    winImage = @"win";
    currentPosition = _labyrinthObject.beginningCell.intValue;
    
    _labyrinth.dataSource = self;
    _labyrinth.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)sendStepWithString:(NSString*)sendString {
     return [[SocketHelper sharedInstance] sendString:sendString];
}

-(NSString*)receiveAnswer {
    return [[SocketHelper sharedInstance] receiveString];
}

-(void)parseAnswerString:(NSString*)string {
    NSString* answerCodeString = [string substringWithRange:NSMakeRange(2, 1)];
    int answerCode = answerCodeString.intValue;
    BOOL finished = NO;
    switch (answerCode) {
        case 0:
            NSLog(@"Error making step! Do nothing.");
            return;
        case 2:
            NSLog(@"That's a finish!");
            finished = YES;
            break;
        default:
            NSLog(@"OK step.");
            break;
    }
    NSString* cellString = [string substringWithRange:NSMakeRange(0, 2)];
    int cellAsInt = cellString.intValue;
    [self goToCell:cellAsInt finished:finished];
}

-(void)goToCell:(int)cell finished:(BOOL)finished {
    NSIndexPath* oldIndexPath = [NSIndexPath indexPathForItem:currentPosition inSection:0];
    LabyrinthCell* oldLabyrinthCell = (LabyrinthCell*)[_labyrinth cellForItemAtIndexPath:oldIndexPath];

    
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:(NSInteger)cell inSection:0];
    LabyrinthCell* newLabyrinthCell = (LabyrinthCell*)[_labyrinth cellForItemAtIndexPath:newIndexPath];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        oldLabyrinthCell.personImage.hidden = YES;
        newLabyrinthCell.personImage.hidden = NO;
    });
    
    currentPosition = cell;
    
    if (finished) {
        [newLabyrinthCell.personImage setImage: [UIImage imageNamed:winImage]];
        UIAlertAction *dismissAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
        [self showAlertWithTitle:@"Congratulations!" message:@"You won! Press \"OK\" to return to menu." andAction:dismissAction];
        
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numOfItems = _labyrinthObject.numOfCellsHorizontal.intValue * _labyrinthObject.numOfCellsVertical.intValue;
    NSLog(@"%d", numOfItems);
    return numOfItems;
}

-(void)configureCell:(LabyrinthCell*) cell atIndexPath: (NSIndexPath*)indexPath {
    if (currentPosition == indexPath.item) {
        cell.personImage.hidden = NO;
    }
    
    NSArray* bordersEncoded = _labyrinthObject.bordersEncoded;
    NSArray* bordersForCell = (NSArray*)[bordersEncoded objectAtIndex:indexPath.item];

    if (indexPath.item == 31) {
        NSLog(@"borders %@", bordersForCell);
    }
        for (int i = 0; i < 4; i++) {
        NSNumber* boolForBorder = (NSNumber*)[bordersForCell objectAtIndex:i];
            if (indexPath.item == 31) {
                NSLog(@"bool for border %d %@", i, boolForBorder);
            }

        if (boolForBorder.intValue == 0) {
            switch (i) {
                case 0:
                    cell.upBorder.hidden = NO;
                    break;
                case 1:
                    cell.downBorder.hidden = NO;
                    break;
                case 2:
                    cell.rightBorder.hidden = NO;
                    break;
                case 3:
                    cell.leftBorder.hidden = NO;
                    break;
            }
        }
    }
    
}

#pragma mark - Collection View Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LabyrinthCell *cell = (LabyrinthCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"labyrinthCell" forIndexPath:indexPath];
    
    cell.personImage.hidden = YES;
    cell.upBorder.hidden = YES;
    cell.downBorder.hidden = YES;
    cell.rightBorder.hidden = YES;
    cell.leftBorder.hidden = YES;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Collection View Flow Layout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(0, 0);
    
    CGFloat collectionViewWidth = _labyrinth.bounds.size.width;
    int numOfCellsHorizontally = _labyrinthObject.numOfCellsHorizontal.intValue;
    CGFloat singleCellWidth = collectionViewWidth/numOfCellsHorizontally - 1.0;
    
    size.width = singleCellWidth;
    size.height = singleCellWidth;
    return size;
}


- (IBAction)stepButtonTapped:(id)sender {

    long buttonTag = ((UIButton*)sender).tag;
    NSString* positionString;
    if (currentPosition < 10) {
        positionString = [NSString stringWithFormat:@"0%d", currentPosition];
    } else {
        positionString = [NSString stringWithFormat:@"%d", currentPosition];
    }
    
    NSString* sendString = [NSString stringWithFormat:@"%@%ld", positionString, buttonTag];
    [self sendStepWithString:sendString];
    NSString* answerString = [self receiveAnswer];
    if (answerString.length > 0) {
        [self parseAnswerString:answerString];
    }
}

@end
