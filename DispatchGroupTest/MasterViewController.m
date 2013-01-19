//
//  MasterViewController.m
//  DispatchGroupTest
//
//  Created by 能登 要 on 13/01/19.
//  Copyright (c) 2013年 irimasu. All rights reserved.
//

#import "MasterViewController.h"
#import "GoupTestViewController.h"
#import "GoupTest2ViewController.h"

@interface MasterViewController () {

}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = indexPath.row == 0 ? @"完了後に纏め仕事" : @"完了後に纏め仕事2";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* viewController = indexPath.row == 0 ? [[GoupTestViewController alloc] initWithNibName:@"GoupTestViewController" bundle:nil] : [[GoupTest2ViewController alloc] initWithNibName:@"GoupTest2ViewController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
