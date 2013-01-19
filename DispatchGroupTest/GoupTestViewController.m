//
//  GoupTestViewController.m
//  DispatchGroupTest
//
//  Created by 能登 要 on 13/01/19.
//  Copyright (c) 2013年 irimasu. All rights reserved.
//

#import "GoupTestViewController.h"
#include <dispatch/dispatch.h>

@interface GoupTestViewController ()
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIImageView *_imageView2;
    __weak IBOutlet UIImageView *_imageView3;
    
    __weak NSURLConnection* _connection;
    __weak NSURLConnection* _connection2;
    __weak NSURLConnection* _connection3;
    
    NSMutableData* _data;
    NSMutableData* _data2;
    NSMutableData* _data3;
    
    dispatch_group_t _group;
}

@end

@implementation GoupTestViewController

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
 
    
    NSArray* URLs = @[@"http://irimasu.com/files/FlashAgent_512x512.jpg",@"http://irimasu.com/files/WallPaperOblongood_512x512.jpg",@"http://irimasu.com/files/GL01PStatus_512x512.jpg"];

    _group = dispatch_group_create();
        // グループを作成
    
    for( NSString* textURL in URLs ){
        NSURL* URL = [NSURL URLWithString:textURL];
        
        NSURLConnection* connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:URL] delegate:self];
        
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
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    }else if( connection == _connection2 ){
        dispatch_group_leave(_group);
    }else if( connection == _connection3 ){
        dispatch_group_leave(_group);
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if( connection == _connection ){
        dispatch_group_leave(_group);
    }else if( connection == _connection2 ){
        dispatch_group_leave(_group);
    }else if( connection == _connection3 ){
        dispatch_group_leave(_group);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
