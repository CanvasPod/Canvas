//
//  CSAnimationTableViewController.m
//  Canvas
//
//  Created by Jamz Tang on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSAnimationTableViewController.h"
#import "Canvas.h"

@interface CSAnimationTableViewController ()

@end

@implementation CSAnimationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"CSSectionHeaderCell" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forCellReuseIdentifier:self.sectionHeaderCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view startCanvasAnimation];
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



#pragma mark - 

@implementation CSAnimationContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-animations-active"];
    self.tabBarItem.image = [UIImage imageNamed:@"icon-animations"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end