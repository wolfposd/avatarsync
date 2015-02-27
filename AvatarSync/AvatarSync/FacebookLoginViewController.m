//
//  FacebookLoginViewController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 07.12.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "FacebookLoginViewController.h"

@interface FacebookLoginViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FacebookLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* start = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(startFetching:)];
    
    self.navigationItem.rightBarButtonItem = start;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) startFetching:(id) sender
{
    NSString* yourHTMLSourceCodeString = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSLog(@"%@", yourHTMLSourceCodeString);
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/friends"]];
    [self.webView loadRequest:req];
    
    
    
    self.webView.delegate = self;
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@", @"done");
}

@end
