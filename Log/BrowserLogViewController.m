//
//  BrowserLogViewController.m
//  SmartLightControl
//
//  Created by 李凯 on 2020/3/26.
//  Copyright © 2020 李凯. All rights reserved.
//

#import "BrowserLogViewController.h"
#import "LogTableViewCell.h"
#import "LogDataModel.h"
#import "BrowserLogViewModel.h"

@interface BrowserLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *logTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterLogViewHeight;


@property (weak, nonatomic) IBOutlet BrowserLogViewModel *viewModel;

@end

@implementation BrowserLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:([LogTableViewCell class])
                                                             forIndexPath:indexPath];
    LogDataModel *log = _viewModel.logs[indexPath.row];
    [cell setValues:log];
    
    return cell;
}



@end
