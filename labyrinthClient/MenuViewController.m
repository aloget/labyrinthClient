//
//  MenuViewController.m
//  labyrinthClient
//
//  Created by Anna on 23/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ShowAlertView.h"


@interface MenuViewController () {
    NSString* sendKeyword;
    NSManagedObjectContext* moc;
    NSFetchedResultsController* frc;
}


@end


@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sendKeyword = @"lab";
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    moc = delegate.managedObjectContext;
    
    if ([[SocketHelper sharedInstance] connected]) {
        NSFetchRequest* fRequest = [NSFetchRequest fetchRequestWithEntityName:@"Labyrinth"];
        NSSortDescriptor* sDescriptor = [[NSSortDescriptor alloc] initWithKey: @"numOfCellsHorizontal" ascending:true];
        NSArray* sDescriptors = [[NSArray alloc] initWithObjects:sDescriptor, nil];
        fRequest.sortDescriptors = sDescriptors;
        
        frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        frc.delegate = self;
        NSError* error;
        if ([moc countForFetchRequest:fRequest error:&error] == 0) {
            if ([self requestLabyrinth]) {
                NSString* labyrinthString = [self getLabytinth];
                if (labyrinthString.length > 0) {
                    Labyrinth* newLabyrinth = (Labyrinth*)[NSEntityDescription insertNewObjectForEntityForName:@"Labyrinth" inManagedObjectContext:moc];
                    [newLabyrinth loadWithSymbolsString:labyrinthString];
                    [delegate saveContext];
                    
                }
            }
        }
        NSError* fError;
        [frc performFetch:&fError];
        if (error != nil) {
            NSLog(@"%@", fError);
        }
    }
    else {
        [self showAlertWithTitle:@"Oops!" andMessage:@"Couldn't connect to server. Relaunch please!"];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)requestLabyrinth {
    return [[SocketHelper sharedInstance] sendString:@"lab"];
}

-(NSString*)getLabytinth {
    return [[SocketHelper sharedInstance] receiveString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* sections = [frc sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    NSLog(@"numofobjs %lu", (unsigned long)[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

#pragma mark - Fetched results controller delegate 

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        NSArray* indexpathArray = [NSArray arrayWithObject:newIndexPath];
        [self.tableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeDelete) {
        NSArray* indexpathArray = [NSArray arrayWithObject:indexPath];
        [self.tableView deleteRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeUpdate) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell != nil) {
            [self configureCell:cell atIndexPath:indexPath];
        }
    }
    if (type == NSFetchedResultsChangeMove) {
        NSArray* oldIndexpathArray = [NSArray arrayWithObject:indexPath];
        NSArray* newIndexpathArray = [NSArray arrayWithObject:newIndexPath];
        [self.tableView deleteRowsAtIndexPaths:oldIndexpathArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:newIndexpathArray withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)configureCell:(UITableViewCell*) cell atIndexPath: (NSIndexPath*)indexPath {
     Labyrinth* labyrinth = [frc objectAtIndexPath:indexPath];
     NSString* labelString = [NSString stringWithFormat:@"Labyrinth %@ x %@ cells", labyrinth.numOfCellsHorizontal, labyrinth.numOfCellsVertical];
     [cell.textLabel setText:labelString];
     cell.textLabel.textAlignment = NSTextAlignmentCenter;
     cell.textLabel.shadowColor = [UIColor blackColor];
     cell.backgroundColor = [UIColor lightGrayColor];
    
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"game"]) {
        UITableViewCell* cell = (UITableViewCell*)sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        Labyrinth* labyrinth = [frc objectAtIndexPath:indexPath];
        GameViewController* gameVC = (GameViewController*)[segue destinationViewController];
        gameVC.labyrinthObject = labyrinth;
    }
}


@end
