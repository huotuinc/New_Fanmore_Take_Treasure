//
//  ListTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/2/15.
//  Copyright © 2016年 车. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UILabel+FMLableStyle.h"
#import "CartModel.h"
#import "UIImageView+WebCache.h"
@implementation ListTableViewCell

//选中按钮点击事件
-(void)clickButtonSelected:(UIButton*)button
{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}

// 数量加按钮
-(void)addBtnClick
{
    if (self.numAddBlock) {
        self.numAddBlock();
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}




- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVGoods.image=[UIImage imageNamed:@"mine_buy"];
    for (int i=0; i<2; i++) {
        UIButton *btn=[self viewWithTag:200+i];
        btn.layer.borderColor=[UIColor grayColor].CGColor;
        btn.layer.borderWidth=1;
    }
    _labelTop.backgroundColor = [UIColor grayColor];
    _labelBottom.backgroundColor = [UIColor grayColor];

//    _textFNumber.layer.borderWidth=1;
//    _textFNumber.layer.borderColor=[UIColor grayColor].CGColor;
    _textFNumber.keyboardType = UIKeyboardTypeNumberPad;
    _textFNumber.textColor = COLOR_BUTTON_ORANGE;
    
    [UILabel changeLabel:_labelTitle AndFont:24 AndColor:COLOR_TEXT_TITILE];
    _labelTitle.numberOfLines=2;
    [UILabel changeLabel:_labelRest AndFont:22 AndColor:COLOR_SHINE_BLUE];
    [UILabel changeLabel:_labelTotal AndFont:22 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelNotice AndFont:22 AndColor:COLOR_BUTTON_ORANGE];
    [UILabel changeLabel:_lableAttend AndFont:22 AndColor:COLOR_TEXT_DATE];
    
    [_buttonAdd setTitle:@"+" forState:UIControlStateNormal];
    [_buttonCut setTitle:@"-" forState:UIControlStateNormal];

//    [UIButton changeButton:_buttonAdd AndFont:50 AndTitleColor:COLOR_TEXT_CONTENT AndBackgroundColor:nil AndBorderColor:[UIColor grayColor] AndCornerRadius:0 AndBorderWidth:1];
//    [UIButton changeButton:_buttonCut AndFont:50 AndTitleColor:COLOR_TEXT_CONTENT AndBackgroundColor:nil AndBorderColor:[UIColor grayColor] AndCornerRadius:0 AndBorderWidth:1];
    [_buttonSelected setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose_none"] forState:UIControlStateNormal];
    
    [_buttonSelected setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose"] forState:UIControlStateSelected];
    
    [_buttonCut addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAdd addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAdd setTitleColor:COLOR_TEXT_DATE forState:UIControlStateNormal];
    [_buttonCut setTitleColor:COLOR_TEXT_DATE forState:UIControlStateNormal];
//    _buttonCut.titleLabel.font = [UIFont systemFontOfSize:ADAPT_HEIGHT(32)];
//    _buttonAdd.titleLabel.font = [UIFont systemFontOfSize:ADAPT_HEIGHT(32)];
    _buttonCut.titleLabel.textColor = COLOR_TEXT_DATE;
    _buttonAdd.titleLabel.textColor = COLOR_TEXT_DATE;
    [_buttonSelected addTarget:self action:@selector(clickButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    _buttonSelected.selected = self.isSelected;
    
    _imageVLine.image = [UIImage imageNamed:@"line_huise"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


}
//@property (nonatomic, strong) NSNumber *areaAmount;
//@property (nonatomic, strong) NSNumber *attendAmount;
//@property (nonatomic, copy) NSString *pictureUrl;
//@property (nonatomic, strong) NSNumber *pid;
//@property (nonatomic, strong) NSNumber *remainAmount;
//@property (nonatomic, copy) NSNumber *stepAmount;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, strong) NSNumber *toAmount;
//@property (nonatomic,assign) BOOL isSelect;
- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    if ([data isMemberOfClass:[CartModel class]]) {
        
        [self storeWeakValueWithData:data indexPath:indexPath];
        
        CartModel *model = (CartModel*)data;
        self.isCellSelect = model.isSelect;

        [_imageVGoods sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
        _labelTitle.text=model.title;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@人次",model.remainAmount]];
        [attString addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_DATE range:NSMakeRange(0, 2)];
        _labelRest.attributedText = attString;
        _labelTotal.text=[NSString stringWithFormat:@"总需%@人次",model.toAmount];
        _textFNumber.text=[NSString stringWithFormat:@"%@",model.userBuyAmount
];
        _textFNumber.tag = 300 + indexPath.row;
        if (![model.stepAmount isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            _labelNotice.text = [NSString stringWithFormat:@"只支持%@的倍数",model.areaAmount];
        }else{
            _labelNotice.text = @"";
            
        }
        _buttonSelected.selected = self.isCellSelect;

        
    }
    
}
//-(void)reloadDataWith:(CartModel*)model{
//    [_imageVGoods sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
//    _labelTitle.text=model.title;
//    _labelRest.text=[NSString stringWithFormat:@"剩余%@人次",model.remainAmount];
//    _labelTotal.text=[NSString stringWithFormat:@"总需%@人次",model.areaAmount];
//    _textFNumber.text=[NSString stringWithFormat:@"%@",model.attendAmount];
//    if (![model.areaAmount isEqualToNumber:[NSNumber numberWithInteger:1]]) {
//        _labelNotice.text = [NSString stringWithFormat:@"只支持%@的倍数",model.areaAmount];
//    }else{
//        _labelNotice.text = @"";
//        
//    }
//    _buttonSelected.selected = self.isSelected;
//
//}


- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
}

-(void)drawRect:(CGRect)rect{
    _imageVGoods.layer.cornerRadius=_imageVGoods.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  键盘监听
 *
 *  @param sender <#sender description#>
 */
-(void)KeyboardWillShow:(NSNotification *)sender
{
    CGRect rect  = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height =  rect.size.height;
    _keyBoardHeight=height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue]
     ];
    [UIView commitAnimations];//开始执行动画
}
-(void)KeyboardWillHide:(NSNotification *)sender
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue]];
    self.transform = CGAffineTransformIdentity; //重置状态
    [UIView commitAnimations];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFNumber resignFirstResponder];
    
    
    
}



@end
