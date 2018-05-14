//
//  ViewController.m
//  iOS_Font_Alignment
//
//  Created by ds.sunagy on 2018/5/14.
//  Copyright © 2018年 ds.sunagy. All rights reserved.
//

#import "ViewController.h"

#import "CoreText/CTFontDescriptor.h"
#import "CoreText/CTFont.h"

#import "VerticallyAlignedLabel.h"
@interface ViewController ()
{
    UITextView *_fLabelView;
    NSString   * _errorMessage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //==========斜体 这种 整个控件也斜了
    //    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, 200, 40)];
    //    lbl.backgroundColor = [UIColor orangeColor];
    //    lbl.text = @"中文斜体";
    //    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
    //    lbl.transform = matrix;
    //    [self.view addSubview:lbl];
    
    //===========对齐方法 垂直对齐方法
    //        VerticallyAlignedLabel * lbl = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(100, 250, 200, 200)];
    //        lbl.backgroundColor = [UIColor yellowColor];
    //        lbl.text = @"中文斜sssssdfasdfasdfasfasdffwergtrgvfWefdfwedeagfv ss体";
    //        lbl.verticalAlignment= VerticalAlignmentMiddle;
    //        lbl.textAlignment=NSTextAlignmentCenter;
    //        lbl.numberOfLines=0;
    //        [self.view addSubview:lbl];
    
    
    //  ==================  AmericanTypewriter-Bold 黑体。   Kaiti HC 楷体   Songti SC
    _fLabelView = [[UITextView alloc] initWithFrame:CGRectMake(50, 100, 250, 100)];
    _fLabelView.backgroundColor=[UIColor yellowColor];
    _fLabelView.font = [UIFont fontWithName:@"Songti SC" size:10];
    NSLog(@"====$@===%@",[UIFont familyNames]);
    _fLabelView.text = @"欢迎查看我的博客";
    [self contentSizeToFit:1];
    
    // 斜体。 只是控件内容斜体
    CGAffineTransform matrix1 =CGAffineTransformMake(1, 0, tanf(20 * (CGFloat)M_PI / 180), 1, 0, 0);//设置反射。倾斜角度。
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName :[UIFont systemFontOfSize:14].fontName matrix :matrix1];//取得系统字符并设置反射。
    _fLabelView.font = [ UIFont fontWithDescriptor :desc size :14];
    [self.view addSubview:_fLabelView];
    // 动态下载字体 （缺点，速度较慢）
    //  [self asynchronouslySetFontName:@"STHeitiSC-Medium"];
}


- (void)contentSizeToFit:(int) type {
    //先判断一下有没有文字
    if([_fLabelView.text length]>0) {
        //textView的contentSize属性
        CGSize contentSize = _fLabelView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= _fLabelView.frame.size.height) {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = 0;
            if(type == 0){
                offsetY = 0;
            }else if(type == 1){
                offsetY = (_fLabelView.frame.size.height - contentSize.height)/2;
            }else if(type == 2){
                offsetY = (_fLabelView.frame.size.height - contentSize.height);
            }
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        } else //如果文字高度超出textView的高度
        {
            newSize =_fLabelView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > _fLabelView.frame.size.height) {
                [_fLabelView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = _fLabelView.contentSize;
            }
            newSize = contentSize;
        }
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [_fLabelView setContentSize:newSize];
        [_fLabelView setContentInset:offset];
    }
    
}

// 动态下载字体
- (void)asynchronouslySetFontName:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:14];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        _fLabelView.text = @"欢迎查看我的博客";
        _fLabelView.font = [UIFont fontWithName:fontName size:14];
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show an activity indicator
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the activity indicator
                
                // Display the sample text for the newly downloaded font
                self -> _fLabelView.text = @"欢迎查看我的博客";
                self ->  _fLabelView.font = [UIFont fontWithName:fontName size:14];
                
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                self->   _errorMessage = [error description];
            } else {
                self->  _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Download error: %@",self-> _errorMessage);
            });
        }
        return (bool)YES;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
