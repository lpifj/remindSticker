//
//  ViewController.m
//  SampleZXing3
//
//  Created by 池田昂平 on 2014/08/09.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//静止画像読み取りボタンが押されたとき
- (IBAction)imageReadPressed:(id)sender {
    //    [self decoder:[UIImage imageNamed:@"qrcode_carrot.png"]];
    
    // 読み取り画面を生成します。
    ZXingWidgetController *zxingWidgetController2 = [[ZXingWidgetController alloc]
                                                     initWithDelegate:self
                                                     showCancel:YES
                                                     OneDMode:NO];
    QRCodeReader *qrcodeReader2 = [[QRCodeReader alloc] init];
    zxingWidgetController2.readers = [[NSSet alloc] initWithObjects:qrcodeReader2, nil];
    
    //画像指定
//    UIImage *image = [UIImage imageNamed:@"qrcode_carrot.png"];
//    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    
//    Decoder* d = [[Decoder alloc] init];
//    TwoDDecoderResult* twod = [[TwoDDecoderResult alloc] init];
    
//    [self decodeImage:image];
//    bool decode = [self performSelector:@selector(decodeImage:) withObject:(image)];
//    [zxingWidgetController2 decoder:d didDecodeImage:image usingSubset:image withResult:twod];
    
//    NSLog(@"%d", decode);
    
    
    // 読み取り画面を表示します。
    [self presentViewController:zxingWidgetController2 animated:NO completion:nil];
    
    NSLog(@"imageReadPressed");
}

//文字列を表示する
- (void)showStringFromTwoD:(ZXingWidgetController*)controller
             didScanResult:(NSString *)result
{
    NSLog(@"%@", result);
}



- (IBAction)showReadViewPressed:(id)sender
{
    // 読み取り画面を生成します。
    ZXingWidgetController *zxingWidgetController = [[ZXingWidgetController alloc]
                                                    initWithDelegate:self
                                                    showCancel:YES
                                                    OneDMode:NO];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    zxingWidgetController.readers = [[NSSet alloc] initWithObjects:qrcodeReader, nil];
    
    // 読み取り画面を表示します。
    [self presentViewController:zxingWidgetController animated:NO completion:nil];
}

- (void)zxingController:(ZXingWidgetController*)controller
          didScanResult:(NSString *)result
{
    // 読み取り画面を閉じます。
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // ブラウザを起動します。
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    
    //文字をパース
    NSArray *array = [result componentsSeparatedByString:@" "];
    //カテゴリの文字列
    NSString *category = [array objectAtIndex:1];
    //期間の文字列
    NSString *span = [array objectAtIndex:2];
    
    //カメラを起動する
    [self showImagePicker];
    
//    [self addSubview:table]
    
}

//カメラの起動
- (void)showImagePicker{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

//撮影した写真の表示
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //JPEGデータとしてNSDataを作成
    NSData *data = UIImageJPEGRepresentation(image, 0.8f);
    
    //保存先をDocumentsディレクトリに指定
    NSString *path = [NSString stringWithFormat:@"%@/item.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = image;
        //画像をアルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //dataインスタンスをpathに保存
        [data writeToFile:path atomically:YES];
        
    }];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    // 読み取り画面を閉じます。
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
