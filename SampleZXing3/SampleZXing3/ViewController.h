//
//  ViewController.h
//  SampleZXing3
//
//  Created by 池田昂平 on 2014/08/09.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import <UIKit/UIView.h>
#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>
#import <TwoDDecoderResult.h>

@interface ViewController : UIViewController
<ZXingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)imageReadPressed:(id)sender;
- (IBAction)showReadViewPressed:(id)sender;
@end
