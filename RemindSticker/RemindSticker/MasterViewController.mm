//
//  MasterViewController.m
//  RemindSticker
//
//  Created by 池田昂平 on 2014/08/12.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "MasterViewController.h"
#import "CoreDataManager.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    //可変配列
    NSMutableArray *_objects;
    
    //2次元コードから取得した文字列の集まり(配列)
    NSArray *array;
    //パ-スした文字列(カテゴリ)
    NSMutableString *category;
    //リストに表示用の文字列(カテゴリ)
    NSString *category_desc;
    
    //パ-スした文字列(期間)
    NSMutableString *span;
    NSString *span_desc;
    
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
    
    //リストに追加
    if(!span_desc && !category_desc){
    [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self insertNewObject:self];
    }
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
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    //セルに文字列を挿入
//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
    
    cell.textLabel.text = span_desc;
    cell.detailTextLabel.text = category_desc;
    NSLog(@"%@", category);
    
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
    
    //取得した文字列の解析
    [self parseStrings:result];
    
    NSLog(@"%@", span);
    
    //カメラを起動する
    [self showImagePicker];
    
//    [self insertNewRemindObject:result];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    // 読み取り画面を閉じます。
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)parseStrings:(NSString*)result{
    //取得した文字列の解析
    array = [result componentsSeparatedByString:@" "];
    //カテゴリの文字列
    category = [NSMutableString stringWithString:[array objectAtIndex:1]];
    [category deleteCharactersInRange:NSMakeRange(0, 9)];
    NSLog(@"%@", category);
    
    category_desc = @"カテゴリ: ";
    if([category isEqualToString:@"vegetable"]){
        category_desc = [category_desc stringByAppendingString:@"野菜"];
    }else{
        category_desc = [category_desc stringByAppendingString:@"未分類"];
    }

    //期間の文字列
    span = [NSMutableString stringWithString:[array objectAtIndex:2]];
    [span deleteCharactersInRange:NSMakeRange(0, 5)];
    NSLog(@"%@", span);
    
    span_desc = @"保存期間: ";
    span_desc = [span_desc stringByAppendingString:span];
//    span_desc = [span_desc stringByAppendingString:@"日間"];
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
    
    
    [self dismissViewControllerAnimated:YES completion:^{

        //画像をアルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    }];
    
}

//写真のセーブが完了すると呼ばれる
- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    NSLog(@"finished");
    //"table:cellForRowAtIndex"メソッドでセルを追加する
    [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self insertNewObject:self];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

//プロパティリストを使って保存
/*
- (void)saveToPlistWithArray:(NSArray *)dataArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.plist"];
    
    BOOL successful = [dataArray writeToFile:filePath atomically:NO];
    
    if (successful) {
        NSLog(@"%@", @"データの保存に成功");
    }
}

- (void)loadFromPlistWithArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    if (dataArray) {
        for (NSString *data in array) {
            NSLog(@"%@", data);
        }
    }
    else {
        NSLog(@"%@", @"データがありません。");
    }
}
*/

//オブジェクトアーカイブ 保存
- (void)saveData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    //category_descとspan_descを保存
    NSArray *dataArray = @[category_desc, span_desc];
    BOOL successful = [NSKeyedArchiver archiveRootObject:dataArray toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
    }
}

//オブジェクトアンアーカイブ 復元
- (NSArray *)loadData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (dataArray) {
        for (NSString *data in dataArray) {
            NSLog(@"%@", data);
        }
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
    
    return dataArray;
}

@end
