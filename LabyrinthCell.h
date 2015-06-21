//
//  LabyrinthCell.h
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabyrinthCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *rightBorder;
@property (weak, nonatomic) IBOutlet UIView *leftBorder;
@property (weak, nonatomic) IBOutlet UIView *downBorder;
@property (weak, nonatomic) IBOutlet UIView *upBorder;

@property (weak, nonatomic) IBOutlet UIImageView *personImage;


@end
