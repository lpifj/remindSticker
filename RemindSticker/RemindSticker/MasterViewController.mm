//
//  MasterViewController.m
//  RemindSticker
//
//  Created by 池田昂平 on 2014/08/12.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    //可変配列
    NSMutableArray *_objects;
    
    //2次元コードから取得した文字列の集まり(配列)
    NSArray *array;
    //パ-スした文字列(カテゴリ)
    NSString *category;
    //パ-スした文字列(期間)
    NSString *span;
    //カメラで撮った画像
    UIImage *image;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //追加ボタンの生成
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//追加ボタンを押したときに,リストに追加するオブジェクトを生成
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    //日付を挿入
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//- (void)insertNewRemindObject:(NSString *)result
//{
//    //文字をパース
//    array = [result componentsSeparatedByString:@" "];
//    //カテゴリの文字列
//    category = [array objectAtIndex:1];
//    //期間の文字列
//    span = [array objectAtIndex:2];
//    
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    //期限を挿入
//    [_objects insertObject:span atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

//新たなセルを追加
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //セルに文字列を挿入
//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
    cell.textLabel.text = span;
    //セルに画像を挿入
    if (image != NULL) {
        cell.imageView.image = image;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"carrot.png"];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (IBAction)showReadViewPressed:(id)sender {
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
    
    //文字をパース
    array = [result componentsSeparatedByString:@" "];
    //カテゴリの文字列
    category = [array objectAtIndex:1];
    //期間の文字列
    span = [array objectAtIndex:2];
    
    //カメラを起動する
    [self showImagePicker];
    //セルを追加するtable:cellForRowAtIndexメソッドを呼び出す
    [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self insertNewRemindObject:result];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    // 読み取り画面を閉じます。
    [self dismissViewControllerAnimated:NO completion:nil];
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
    
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //①JPEGデータとしてNSDataを作成
//    NSData *data = UIImageJPEGRepresentation(image, 0.8f);
    
    //②保存先をDocumentsディレクトリに指定
//    NSString *path = [NSString stringWithFormat:@"%@/item.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        self.imageView.image = image;
        //画像をアルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //③dataインスタンスをpathに保存
//        [data writeToFile:path atomically:YES];
    }];
    
}
@end
