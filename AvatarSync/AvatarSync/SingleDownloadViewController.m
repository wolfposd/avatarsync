//
//  SingleDownloadViewController.m
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SingleDownloadViewController.h"
#import "ContactsTableViewController.h"

@interface SingleDownloadViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) id<SingleDownloadDelegate> delegate;
@property (nonatomic,retain) ASPerson* person;
@property (nonatomic, retain) UIImage* image;


@property (weak, nonatomic) IBOutlet UITextField *urlTextfield;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@end

@implementation SingleDownloadViewController



-(id) initWithPerson:(ASPerson*) person andDelegate:(id<SingleDownloadDelegate>) delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _delegate = delegate;
        _person = person;
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.activityIndicator.hidesWhenStopped = NO;
    self.activityIndicator.hidden = YES;
    
    self.view.backgroundColor = [self.delegate backgroundColor];
    
    self.title = [self.delegate titleForNav];
    
    
    self.headerLabel.text = [self.delegate titleForLabel];
    self.headerLabel.textColor = [self.delegate labelColor];
    self.footerLabel.textColor = [self.delegate labelColor];
    
    
    self.imageView.image = [UIImage imageNamed:@"noimage.png"];
    
    
    [self.downloadButton setTitle:NSLocalizedString(@"Download", nil) forState:UIControlStateNormal];
    [self.applyButton setTitle:NSLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
    
    [_delegate setOwner:self];
}

- (IBAction)downloadTouchUpInside:(id)sender
{
    if(self.urlTextfield.text.length > 0 )
    {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [self.delegate startDownloading:self.urlTextfield.text];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What now?!",nil) message:[self.delegate errorNoText] delegate:self cancelButtonTitle:NSLocalizedString(@"Gotcha!",nil) otherButtonTitles: nil];
        [alert show];
    }
    
    
    [self.urlTextfield resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)applyTouchUpInside:(id)sender
{
    if(self.image)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Apply Image",nil) message:NSLocalizedString(@"Are you sure you want to apply this image to user?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Yes",nil) otherButtonTitles:NSLocalizedString(@"No",nil), nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What now?!",nil) message:NSLocalizedString(@"Please download an image before applying it!",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Gotcha!",nil) otherButtonTitles: nil];
        [alert show];
    }
}

-(void) setAnimating:(BOOL) animate
{
    self.activityIndicator.hidden = !animate;
    
    if(animate)
    {
        [self.activityIndicator startAnimating];
    }
    else
    {
        [self.activityIndicator stopAnimating];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && alertView.numberOfButtons >= 2)
    {
        [self.person updateImage:self.image];
        
        id firstCon = self.navigationController.viewControllers.firstObject;
        if([firstCon respondsToSelector:@selector(saveAddressbook)])
        {
            [firstCon saveAddressbook];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - SingleDownloadOwner

-(void) reportDownloadFinishedWithImage:(UIImage*) image
{
    self.image = image;
    self.imageView.image = image;
    self.footerLabel.text = NSLocalizedString(@"Successfully Downloaded",nil);
    [self setAnimating:false];
}

-(void) errorHappenedDuringDownload:(NSString*) errortext
{
    self.footerLabel.text = errortext;
    [self setAnimating:false];
}

-(void) putStringInTextfield:(NSString*) string
{
    self.urlTextfield.text = string;
}


@end
