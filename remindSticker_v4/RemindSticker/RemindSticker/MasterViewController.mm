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
#import "AppDelegate.h"

@interface MasterViewController () {
    //可変配列
    NSMutableArray *_objects;
    
    //パ-スした文字列(カテゴリ)
    NSMutableString *category;
    //リストに表示用の文字列(カテゴリ)
    NSString *category_desc;
    
    //パ-スした文字列(期間)
    //NSMutableString *span;
    NSInteger span;
    NSString *span_desc;
    
    //カメラで撮った画像
    UIImage *image;
    
    //期日
    //NSMutableString *deadline;
    NSDate *deadline;
    //NSInteger *currentYear;
    //NSInteger *currentMonth;
    //NSInteger *currentDay;
    
    //セルの数
    NSInteger *cellNum;
    
    //一つのセル情報を格納(category_desc, span_desc, image, deadline)
    NSArray *dataSet;
    
    //NSArray *loadDataSet;
    NSMutableArray *loadCategories;
    NSMutableArray *loadSpans;
    NSMutableArray *loadImages;
    
    //dataセットを格納
    NSMutableArray *dataSetArray;
    
    //オブジェクトの復元と代入
    NSMutableArray *loadDataSetArray;
    
    int i;
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
    
    //AppdelegateのviewController変数に自分を代入する.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.masterViewController = self;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //追加ボタンの生成
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //配列の初期化
    dataSetArray = [[NSMutableArray alloc] init];
    //空のデータを上書き
    [self saveData];
    
    //loadDataが空でなければリストに追加
    /*
        if([self loadData]!= nil){
            NSLog(@"loadDataを開始します");
            //オブジェクトの復元と代入
            
            NSArray *loadData = [self loadData];
            
                category_desc = [NSString stringWithString:[loadData objectAtIndex:0]];
                span_desc = [NSString stringWithString:[loadData objectAtIndex:1]];
                image = [loadData objectAtIndex:2];
                
                NSLog(@"category_descの中身%@", category_desc);
                NSLog(@"span_descの中身%@", span_desc);
                
                [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self insertNewObject:self];
        }
    */
    
    if([self loadData]!= nil){
        NSLog(@"loadDataを開始します");
        
//        loadDataSetArray = [[NSMutableArray alloc] init];
        loadDataSetArray = [self loadData];
        NSLog(@"%@", loadDataSetArray);
        
        //dataSetを取り出す
        for(NSArray *loadDataSet in loadDataSetArray){
            /*
            category_desc = [NSString stringWithString:[loadDataSet objectAtIndex:0]];
            span_desc = [NSString stringWithString:[loadDataSet objectAtIndex:1]];
            image = [loadDataSet objectAtIndex:2];
            
            NSLog(@"category_descの中身%@", [loadDataSet objectAtIndex:0]);
            NSLog(@"span_descの中身%@", [loadDataSet objectAtIndex:1]);
            */
            
            
            [self devideLoadDataSet:loadDataSet];

            /*
            [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self insertNewObject:self];*/
            
            /*
            [self devideLoadDataSet:loadDataSet completion:^ {
                
                [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self insertNewObject:self];
            }];
             */
        }
        
//        loadCategories = [[NSMutableArray alloc] init];
//        loadSpans = [[NSMutableArray alloc] init];
//        loadImages = [[NSMutableArray alloc] init];
        
        //配列を2個用意してみる.
//        for(NSArray *loadDataSet in loadDataSetArray){
//            
//            //loadDataSetのcategoryを次々に保存
//             [loadCategories addObject:[loadDataSet objectAtIndex:0]];
//             [loadSpans addObject:[NSString stringWithString:[loadDataSet objectAtIndex:1]]];
//             [loadImages addObject:[loadDataSet objectAtIndex:2]];
////            NSLog(@"loadCategoriesの中身%@", loadCategories);
////            NSLog(@"loadSpansの中身%@", loadSpans);
//        }
//
//        
//        for(i=0; i<[loadDataSetArray count]; i++){
//            /*
//            category_desc = [loadCategories objectAtIndex:i];
//            span_desc = [loadSpans objectAtIndex:i];
//            image = [loadImages objectAtIndex:i];
//            */
//            [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            [self insertNewObject:self];
//            
//            NSLog(@"category_descの中身%@", category_desc);
//            NSLog(@"span_descの中身%@", span_desc);
//        }
        
    }else{
         NSLog(@"loadDataを開始しません");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//可変配列_objectに新たなオブジェクトを追加
- (void)insertNewObject:(id)sender
{
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }*/
    //日付を挿入
    /*
    [_objects insertObject:[NSDate date] atIndex:0];*/
    
    //dataSetArrayの先頭にdataSetを挿入
    [dataSetArray insertObject:dataSet atIndex:0];
    
    //更新したdataSetArrayを保存
    [self saveData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSLog(@"insertNewObject");
}

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
    NSArray *object = dataSetArray[indexPath.row];
    
    /*
    category_desc = [NSString stringWithString:[[loadDataSetArray objectAtIndex:0] objectAtIndex:0]];
    span_desc = [NSString stringWithString:[loadDataSetArray objectAtIndex:1]];
    image = [loadDataSetArray objectAtIndex:2];
    
    NSLog(@"devideLoadDataSet category_desc:%@", category_desc);
    NSLog(@"devideLoadDataSet span_desc:%@", span_desc);*/
    
    //dataSetArrayから取り出した要素
    NSMutableString *object_category = object[0];
    NSInteger object_span = (NSInteger)object[1];
    UIImage *object_image = object[2];
    NSDate *object_deadline = object[3];
    
    //セル内に表示するための文字列を作成
    NSString *deadlineString = [self deadlineString:object_deadline];
    NSString *deadlineDescrip = [NSString stringWithFormat:@"使用期限:%@", deadlineString];
    NSString *categoryDescrip = @"カテゴリ:";
    
    if([object_category isEqualToString:@"vegetable"]){
        categoryDescrip = [categoryDescrip stringByAppendingString:@"野菜"];
    }else if([object_category isEqualToString:@"drink"]){
        categoryDescrip = [categoryDescrip stringByAppendingString:@"飲み物"];
    }else if([object_category isEqualToString:@"cooked"]){
        categoryDescrip = [categoryDescrip stringByAppendingString:@"調理済み"];
    }
    else if([object_category isEqualToString:@"frozen"]){
        categoryDescrip = [categoryDescrip stringByAppendingString:@"冷凍食品"];
    }else if([object_category isEqualToString:@"fermented"]){
        categoryDescrip = [categoryDescrip stringByAppendingString:@"発酵食品"];
    }else{
        categoryDescrip = [categoryDescrip stringByAppendingString:@"その他"];
    }
    
    //セル内に期日の表示
    cell.textLabel.text = deadlineDescrip;
    //セル内にカテゴリの表示
    cell.detailTextLabel.text = categoryDescrip;
    
    //セルに画像を挿入
    if (image != NULL) {
        cell.imageView.image = object_image;
    }else{
        //cell.imageView.image = [UIImage imageNamed:@"carrot.png"];
        cell.imageView.image = nil;
    }
    
    NSLog(@"cellForRow span_desc:%@", span_desc);
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
    NSArray *array = [result componentsSeparatedByString:@" "];
    
    //カテゴリの文字列(英字)
    category = [NSMutableString stringWithString:[array objectAtIndex:1]];
    [category deleteCharactersInRange:NSMakeRange(0, 9)];

    //保存期間の文字列
    NSMutableString *spanString = [NSMutableString stringWithString:[array objectAtIndex:2]];
    [spanString deleteCharactersInRange:NSMakeRange(0, 5)];
    
    //保存期間(整数)
    span = (NSInteger)spanString;
    
    //span_desc = @"保存期間: ";
    //span_desc = [span_desc stringByAppendingString:spanString];
    
    //期日(NSDate)
    deadline = [self calcDeadline];
}

//期日を求めるメソッド(NSDate) ← NSDate型にしておくと後々使いやすい.
- (NSDate *)calcDeadline{
    //現在の日付・時刻を取得
    NSDate *now = [NSDate date];
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    //dateByAddingComponentsメソッドを使用する為に作成
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [dc setDay:span];
    
    NSDate *dead = [calendar dateByAddingComponents:dc toDate:now options:0];
    
    return dead;
}

//期日(NSDate)を文字列(String)にするメソッド
- (NSString *)deadlineString:(NSDate *)dead{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:flags fromDate:dead];
    NSInteger deadYear = [comps year];
    NSInteger deadMonth = [comps month];
    NSInteger deadDay = [comps day];
    
    NSString *result = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)deadYear, (long)deadMonth, (long)deadDay];
    
    return result;
}

//deadlineから1週間以内になったかどうか

//現在の年月日の情報を返すメソッド
- (NSDateComponents *)calcCurrentTime{
    //現在の日付・時刻を取得
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:flags fromDate:now];
    
    return comps;
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

//写真のセーブが完了した直後
- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    //配列にセルの情報を全て保存
    //dataSet = @[category, span, image, deadline];
    dataSet = [NSArray arrayWithObjects:category, span, image, deadline, nil];
    
    //dataSetArrayに保存
    //[self saveData];
    
    [self insertNewObject:self];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

//オブジェクトアーカイブ 保存
/*
- (void)saveData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    //category_descとspan_descを保存
    NSArray *dataArray = @[category_desc, span_desc, image];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:dataArray toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
        NSLog(@"%@", dataArray);
    }
}
 */

- (void)saveData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    //dataSetArrayの末尾にdataSetを追加
    //[dataSetArray addObject:dataSet];
    
    //dataSetArrayの先頭にdataSetを追加
    //[dataSetArray insertObject:dataSet atIndex:0];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:dataSetArray toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
        NSLog(@"%@", dataSetArray);
    }
}

//オブジェクトアンアーカイブ 復元
/*
- (NSArray *)loadData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (dataSetArray) {
        for (NSString *data in dataArray) {
            NSLog(@"%@", data);
        }
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
    
    return dataArray;
}
*/

- (NSMutableArray *)loadData{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    dataSetArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (dataSetArray) {
        for (NSString *data in dataSetArray) {
            NSLog(@"復元したデータは%@", data);
        }
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
    
    return dataSetArray;
}


- (void)devideLoadDataSet:(NSArray *)loadDataSet{
//    category_desc = [NSString stringWithString:[loadDataSet objectAtIndex:0]];
//    span_desc = [NSString stringWithString:[loadDataSet objectAtIndex:1]];
//    image = [loadDataSet objectAtIndex:2];
//
//    NSLog(@"devideLoadDataSet category_desc:%@", category_desc);
//    NSLog(@"devideLoadDataSet span_desc:%@", span_desc);
    
    [self insertNewObject:self];
}

/*
- (void)devideLoadDataSet:(NSArray *)loadDataSet completion:(void (^)())completion{
    
    category_desc = [NSString stringWithString:[loadDataSet objectAtIndex:0]];
    span_desc = [NSString stringWithString:[loadDataSet objectAtIndex:1]];
    image = [loadDataSet objectAtIndex:2];
    
    //    NSLog(@"category_descの中身%@", [loadDataSet objectAtIndex:0]);
    //    NSLog(@"span_descの中身%@", [loadDataSet objectAtIndex:1]);
    NSLog(@"category_descの中身%@", category_desc);
    NSLog(@"span_descの中身%@", span_desc);
}
*/

@end
