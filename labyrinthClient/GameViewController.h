//
//  GameViewController.h
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Labyrinth.h"
#import "LabyrinthCell.h"
#import "SocketHelper.h"


@interface GameViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
 

@property Labyrinth* labyrinthObject;

@property (weak, nonatomic) IBOutlet UICollectionView *labyrinth;

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;


- (IBAction)stepButtonTapped:(id)sender;


@end
