//
//  GoupTestViewController.m
//  DispatchGroupTest
//
//  Created by 能登 要 on 13/01/19.
//  Copyright (c) 2013年 irimasu. All rights reserved.
//

#import "GoupTest2ViewController.h"
#include <dispatch/dispatch.h>

@interface GoupTest2ViewController ()
{
    __weak IBOutlet UIImageView *_imageView; // イメージのアウトレット
    __weak IBOutlet UIImageView *_imageView2; // イメージのアウトレット
    __weak IBOutlet UIImageView *_imageView3; // イメージのアウトレット
    
    __weak NSURLConnection* _connection; // 通信用のインスタンス
    __weak NSURLConnection* _connection2; // 通信用のインスタンス 
    __weak NSURLConnection* _connection3; // 通信用のインスタンス
    
    NSMutableData* _data; // 通信データを受け取るオブジェクト
    NSMutableData* _data2; // 通信データを受け取るオブジェクト
    NSMutableData* _data3; // 通信データを受け取るオブジェクト
    
    dispatch_group_t _group; // Dispatch Group のオブジェクト
}

@end

@implementation GoupTest2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // 3つの画像を指定する
    NSArray* URLs = @[@"http://irimasu.com/files/FlashAgent_512x512.jpg",@"http://irimasu.com/files/WallPaperOblongood_512x512.jpg",@"http://irimasu.com/files/GL01PStatus_512x512.jpg"];

    _group = dispatch_group_create();
        // グループを作成
    
    // わざと抜けない処理を記述する
    // 下の部分のわざと抜けない
//    dispatch_group_enter(_group);
    
    
    for( NSString* textURL in URLs ){
        NSURL* URL = [NSURL URLWithString:textURL];
        
        NSURLConnection* connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:URL] delegate:self];
        
        if( connection != nil )
            dispatch_group_enter(_group);
        
        NSUInteger index = [URLs indexOfObject:textURL];
        switch (index) {
        case 0:
            _connection = connection;
            break;
        case 1:
            _connection2 = connection;
            break;
        case 2:
            _connection3 = connection;
            break;
        default:
            break;
        }
    }
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        _imageView.image = [[UIImage alloc] initWithData:_data];
        _imageView2.image = [[UIImage alloc] initWithData:_data2];
        _imageView3.image = [[UIImage alloc] initWithData:_data3];
    });
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
#define CHECK_INTERVAL 1
        
        
        dispatch_time_t timeInterval = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * CHECK_INTERVAL);
        
        BOOL bContinued = YES;
        NSInteger remainCount = 7;
            // リトライカウントを用意する
        while( bContinued ){
            long result = dispatch_group_wait(_group, timeInterval);
            
            // ここで通信状況を確認する
            //
            // wi-fi の通信状況など
            // result を0以外でリトライを開始
            // 
            
            if( result == 0 ){
                bContinued = NO;
                // 完了末必要無し
            }else{
                remainCount--;
                if( remainCount == 0 ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"リトライ回数が無くなったので中断処理を開始する");
                        
                        // ここで中断処理を追加する
                        [_connection cancel];
                        [_connection2 cancel];
                        [_connection3 cancel];
                            // 通信をキャンセルする
                    });
                    bContinued = NO;
                        // チェックから抜ける
                }else{
                    timeInterval = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * CHECK_INTERVAL);
                }
            }
        }
    });
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データの読み込みを開始する
    if( connection == _connection ){
        _data = [[NSMutableData alloc] init];
    }else if( connection == _connection2 ){
        _data2 = [[NSMutableData alloc] init];
    }else if( connection == _connection3 ){
        _data3 = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 送信されてきたデータを受け付ける
    if( connection == _connection ){
        [_data appendData:data];
    }else if( connection == _connection2 ){
        [_data2 appendData:data];
    }else if( connection == _connection3 ){
        [_data3 appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if( connection == _connection ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }else if( connection == _connection2 ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }else if( connection == _connection3 ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if( connection == _connection ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }else if( connection == _connection2 ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }else if( connection == _connection3 ){
        dispatch_group_leave(_group);
            // グループから抜ける
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
