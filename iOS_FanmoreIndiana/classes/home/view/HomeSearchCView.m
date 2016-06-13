//
//  HomeSearchCView.m
//  
//
//  Created by che on 16/2/23.
//
//

#import "HomeSearchCView.h"

@implementation HomeSearchCView

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    _imageVSearch.image = [UIImage imageNamed:@"search"];
    
    
    _viewBase.layer.cornerRadius = 3;
    _viewBase.layer.borderWidth = 1 ;
    _viewBase.layer.borderColor = COLOR_BACK_MAIN.CGColor;
    _viewBase.layer.masksToBounds = YES;
    //    _viewBase.clipsToBounds = YES;
    _imageVSearch.layer.masksToBounds = YES;
    _textFSearch.layer.masksToBounds = YES;
    _viewSearch.layer.masksToBounds = YES;
}

-(void)drawRect:(CGRect)rect{
//    _viewBase.layer.cornerRadius = 20;
//    _viewBase.layer.borderWidth = 1 ;
//    _viewBase.layer.borderColor = COLOR_BACK_MAIN.CGColor;
//    _viewBase.layer.masksToBounds = YES;
////    _viewBase.clipsToBounds = YES;
//    _imageVSearch.layer.masksToBounds = YES;
//    _textFSearch.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
