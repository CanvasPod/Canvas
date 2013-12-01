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
    [self setNeedsStatusBarAppearanceUpdate];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"CSSectionHeaderCell" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forCellReuseIdentifier:self.sectionHeaderCellIdentifier];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell startCanvasAnimation];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell startCanvasAnimation];
    cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.sectionHeaderCellIdentifier];
    cell.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    return cell;
}

@end
