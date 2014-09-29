//
//  MasterViewController.h
//  RemindSticker
//
//  Created by 池田昂平 on 2014/08/12.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import <UIKit/UIView.h>
#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <ZXingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)showReadViewPressed:(id)sender;
@end
