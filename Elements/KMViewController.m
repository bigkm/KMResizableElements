//
//  KMViewController.m
//  Elements
//
//  Created by Kim Hunter on 2/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMViewController.h"
#import "KMCloseButtonView.h"

@implementation KMViewController
@synthesize imageView;
@synthesize numberButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setNumberButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Use defaults like this 
    //imageView.image = [KMCloseButtonView imageWithSize:imageView.frame.size];
    
    // or pass a bock in to setup the view
    imageView.image = [KMCloseButtonView imageWithSize:imageView.frame.size andBlock:^(KMCloseButtonView *btnView) {
        btnView.innerCircleColor = [UIColor redColor];
    }];
    numberButton.text = @"A";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [imageView release];
    [numberButton release];
    [super dealloc];
}
@end
