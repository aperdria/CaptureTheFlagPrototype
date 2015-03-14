//
//  ViewController.m
//  CaptureTheFlagPrototype
//
//  Created by Thomas Riccioli on 14/03/15.
//  Copyright (c) 2015 Thomas Riccioli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDelegate>

@property NSMutableData *responseData;

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

- (IBAction)scanButtonPressed:(id)sender {
	NSLog(@"Scan button pressed");
	
	ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
	codeReader.readerDelegate = self;
	codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
	ZBarImageScanner *scanner = codeReader.scanner;
	[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
	
	[self presentViewController:codeReader animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
	
	ZBarSymbol *symbol = nil;
	for (symbol in results) {
		break;
	}
	
	[picker dismissViewControllerAnimated:YES completion:^{
		[self dataScanEnded:symbol.data];
	}];
}

- (void)dataScanEnded:(NSString *)data {
	NSLog(@"Data scanned: %@", data);
	
	NSString *post = [NSString stringWithFormat: @"login=%@&data=%@", @"login", data];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
 
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	[request setURL:[NSURL URLWithString:@"http://example.com/"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:20.0];
	[request setHTTPBody:postData];
 
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [NSString stringWithUTF8String:[_responseData bytes]];
	NSLog(@"Request succeeded: %@", responseString);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Request failed");
}

@end
