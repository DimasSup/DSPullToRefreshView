//
//  ExampleViewController.h
//  DSPullToRefreshView
//
//  Created by DimasSup on 16.01.15.
//  Copyright (c) 2015 DimasSup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPullToRefreshView.h"

@interface ExampleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DSPullToRefreshViewDelegate>
{
	IBOutlet DSPullToRefreshView* _pullToRefreshView;
	IBOutlet UITableView* _tableView;
	IBOutlet UILabel* _label;
}
@end
