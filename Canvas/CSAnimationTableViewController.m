//
//  CSAnimationTableViewController.m
//  Canvas
//
//  Created by Jamz Tang on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSAnimationTableViewController.h"
#import "CSAnimationView.h"

@interface CSAnimationTableViewController ()

@end

@implementation CSAnimationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(22, 0, 0, 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell startCanvasAnimation];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell startCanvasAnimation];
}

@end
