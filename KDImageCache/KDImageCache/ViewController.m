//
//  ViewController.m
//  KDImageCache
//
//  Created by laikidi on 17/3/21.
//  Copyright © 2017年 KiDiL. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+imageCache.h"
#import "TableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row % 2) {
        [cell.imageView kd_setImageWithURLString:@"http://img.d9soft.com/2016/0412/20160412115102513.jpg"];
    }else{
        [cell.imageView kd_setImageWithURLString:@"http://img.dgtle.com/forum/201510/28/201430buigz9glmn3i3rxg.jpg"];
    }
//    if (indexPath.row % 2) {
//        [cell.cellImageView kd_setImageWithURLString:@"http://img.d9soft.com/2016/0412/20160412115102513.jpg"];
//    }else{
//        [cell.cellImageView kd_setImageWithURLString:@"http://img.dgtle.com/forum/201510/28/201430buigz9glmn3i3rxg.jpg"];
//    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
