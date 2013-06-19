//
//  ViewController.m
//  MercadoCostos
//
//  Created by Brian Krochik on 30/05/13.
//  Copyright (c) 2013 Brian Krochik. All rights reserved.
//

#import "ViewController.h"
#import "PriceCell.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface ViewController ()
{
    UIActivityIndicatorView *_activityIndicatorView;
    UIView *_hudView;
    NSString *countryCode;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSpinner];
    
    //Country
    NSLocale *locale = [NSLocale currentLocale];
    countryCode =[locale objectForKey: NSLocaleCountryCode];
    
    //Delegates
    self.priceTable.dataSource=self;
    self.priceTable.delegate=self;
    self.txtPrice.delegate=self;
    self.txtQty.delegate=self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)btnCalc:(id)sender {
    if(self.txtPrice.text!=nil && ![self.txtPrice.text isEqualToString:@""] && self.txtQty.text!=nil && ![self.txtQty.text isEqualToString:@""]){
         //Back focus keyboard
        [self.txtPrice resignFirstResponder];
        [self.txtQty resignFirstResponder];
         
        //init spinner
        [self.view addSubview:_hudView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [self.priceTable reloadData];
            //Stop Spinner
            [_hudView removeFromSuperview];
        });
    }else{
        UIAlertView *alert;
        if([countryCode isEqualToString:@"BR"]){
            alert = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                               message:@"Você deve digitar caracteres numéricos."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];

        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Atencion"
                                               message:@"Debe ingresar caracteres numericos."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];

        }
                [alert show];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//Table and Cell styles
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    //CELLs
    cell.backgroundColor =[UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    //TABLEVIEW
    tableView.separatorColor= [UIColor grayColor];
}

//Load Spinner
- (void) loadSpinner
{
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    [_hudView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    UILabel *_captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.adjustsFontSizeToFitWidth = YES;
    _captionLabel.textAlignment = UITextAlignmentCenter;
    
    if([countryCode isEqualToString:@"BR"]){
        _captionLabel.text = @"Carregamento...";
    }else{
        _captionLabel.text = @"Calculando...";
    }
    [_hudView addSubview:_captionLabel];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier= @"Cell";
    
    PriceCell *Cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CGFloat strFloat = (CGFloat)[self.txtPrice.text floatValue];
    CGFloat pubQtyFloat = (CGFloat)[self.txtPrice.text floatValue];
    int qty= (int)[self.txtQty.text integerValue];
    pubQtyFloat=pubQtyFloat*qty;
    
    if(!Cell){
        Cell= [[PriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Costo
    CGFloat cost;
    NSString *currency;
    
    #define CASE(str)                       if ([__s__ isEqualToString:(str)])
    #define SWITCH(s)                       for (NSString *__s__ = (s); ; )
    #define DEFAULT
    
    //Cambio calculos dependiendo del site
    SWITCH (countryCode) {
        CASE (@"AR") {
            currency=@"$ ";
            if(indexPath.row==0){
                Cell.txtType.text=@"Oro Premium";
                if(pubQtyFloat<3000)
                    Cell.txtPub.text=@"150";
                if(pubQtyFloat>=3000 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"650";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<1000)
                    Cell.txtPub.text=@"30";
                if(pubQtyFloat>=1000 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"390";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Plata";
                if(pubQtyFloat<400)
                    Cell.txtPub.text=@"4";
                if(pubQtyFloat>=400 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"130";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
                
            }
            
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Gratis";
                if(strFloat<50)
                    Cell.txtSell.text=@"3,25";
                if(strFloat>=50 && strFloat <8500){
                    cost=((strFloat*10)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8500 )
                    Cell.txtSell.text=@"850";
            }
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"%0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"%0.2f",(gan/qty)];
            break;
        }
        CASE (@"BR") {
            currency=@"R$ ";
            self.txtPrice.placeholder=@"Preço";
            self.txtQty.placeholder=@"Quantidade";
            Cell.lblCostPub.text=@"Custo por publicação";
            Cell.lblCostSell.text=@"Custo das vendas";
            Cell.lblGan.text=@"O lucro total";
            Cell.lblGanUnit.text=@"O lucro por unidades";
            if(indexPath.row==0){
                Cell.txtType.text=@"Diamante";
                if(pubQtyFloat<3000)
                    Cell.txtPub.text=@"150";
                if(pubQtyFloat>=3000 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"650";
                
                if(strFloat<15.40)
                    Cell.txtSell.text=@"1";
                if(strFloat>=15.40 && strFloat <6154){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=6154 )
                    Cell.txtSell.text=@"400";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<1167)
                    Cell.txtPub.text=@"35";
                if(pubQtyFloat>=1167 && pubQtyFloat <11667){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=11667)
                    Cell.txtPub.text=@"350";
                
                if(strFloat<15.4)
                    Cell.txtSell.text=@"1";
                if(strFloat>=15.4 && strFloat <6154){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=6154 )
                    Cell.txtSell.text=@"400";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Prata";
                if(pubQtyFloat<100)
                    Cell.txtPub.text=@"1";
                if(pubQtyFloat>=100 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"130";
                
                if(strFloat<15.4)
                    Cell.txtSell.text=@"1";
                if(strFloat>=15.4 && strFloat <6154){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=6154 )
                    Cell.txtSell.text=@"400";
                
            }
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Grátis";
                if(strFloat<10)
                    Cell.txtSell.text=@"1";
                if(strFloat>=10 && strFloat <4000){
                    cost=((strFloat*10)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=4000 )
                    Cell.txtSell.text=@"400";
            }
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"%0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"%0.2f",(gan/qty)];
            break;
        }
        CASE (@"MX") {
            currency=@"$ ";
            if(indexPath.row==0){
                Cell.txtType.text=@"Oro Premium";
                if(pubQtyFloat<11000)
                    Cell.txtPub.text=@"550";
                if(pubQtyFloat>=11000 && pubQtyFloat <44000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=44000)
                    Cell.txtPub.text=@"2200";
                
                if(strFloat<90)
                    Cell.txtSell.text=@"6";
                if(strFloat>=90 && strFloat <30700){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=30700 )
                    Cell.txtSell.text=@"2000";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<4800)
                    Cell.txtPub.text=@"145";
                if(pubQtyFloat>=4800 && pubQtyFloat <40000){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=40000)
                    Cell.txtPub.text=@"1200";
                
                if(strFloat<90)
                    Cell.txtSell.text=@"6";
                if(strFloat>=90 && strFloat <30700){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=30700 )
                    Cell.txtSell.text=@"2000";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Plata";
                if(pubQtyFloat<700)
                    Cell.txtPub.text=@"7";
                if(pubQtyFloat>=700 && pubQtyFloat <44000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=44000)
                    Cell.txtPub.text=@"440";
                
                if(strFloat<90)
                    Cell.txtSell.text=@"6";
                if(strFloat>=90 && strFloat <30700){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=30700 )
                    Cell.txtSell.text=@"2000";
                
            }
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Gratis";
                if(strFloat<60)
                    Cell.txtSell.text=@"6";
                if(strFloat>=60 && strFloat <20000){
                    cost=((strFloat*10)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=20000 )
                    Cell.txtSell.text=@"2000";
            }
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"%0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"%0.2f",(gan/qty)];
            break;
            
        }
        CASE (@"UY") {
            currency=@"$ ";
            if(indexPath.row==0){
                Cell.txtType.text=@"Oro Premium";
                if(pubQtyFloat<7200)
                    Cell.txtPub.text=@"360";
                if(pubQtyFloat>=7200 && pubQtyFloat <16000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=16000)
                    Cell.txtPub.text=@"800";
                
                if(strFloat<200)
                    Cell.txtSell.text=@"10";
                if(strFloat>=200 && strFloat <44000){
                    cost=((strFloat*5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=44000 )
                    Cell.txtSell.text=@"2200";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<3400)
                    Cell.txtPub.text=@"120";
                if(pubQtyFloat>=3400 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"390";
                
                if(strFloat<200)
                    Cell.txtSell.text=@"10";
                if(strFloat>=200 && strFloat <44000){
                    cost=((strFloat*5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=44000 )
                    Cell.txtSell.text=@"2200";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Plata";
                if(pubQtyFloat<1000)
                    Cell.txtPub.text=@"10";
                if(pubQtyFloat>=1000 && pubQtyFloat <10000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=10000)
                    Cell.txtPub.text=@"100";
                
                if(strFloat<200)
                    Cell.txtSell.text=@"10";
                if(strFloat>=200 && strFloat <44000){
                    cost=((strFloat*5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=44000 )
                    Cell.txtSell.text=@"2200";
                
            }
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Gratis";
                if(strFloat<111)
                    Cell.txtSell.text=@"10";
                if(strFloat>=111 && strFloat <24440){
                    cost=((strFloat*9)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=24440 )
                    Cell.txtSell.text=@"2200";
            }
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"%0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"%0.2f",(gan/qty)];
            break;
            
        }
        CASE (@"VE") {
            currency=@"Bs.F. ";
            if(indexPath.row==0){
                Cell.txtType.text=@"Oro Premium";
                if(pubQtyFloat<8000)
                    Cell.txtPub.text=@"Bs.F. 400";
                if(pubQtyFloat>=8000 && pubQtyFloat <25000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(pubQtyFloat>=25000)
                    Cell.txtPub.text=@"Bs.F. 1250";
                
                if(strFloat<100)
                    Cell.txtSell.text=@"Bs.F. 6";
                if(strFloat>=100 && strFloat <20840){
                    cost=((strFloat*6)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(strFloat>=20840 )
                    Cell.txtSell.text=@"Bs.F. 1250";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<3000)
                    Cell.txtPub.text=@"Bs.F. 90";
                if(pubQtyFloat>=3000 && pubQtyFloat <24000){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(pubQtyFloat>=2400)
                    Cell.txtPub.text=@"Bs.F. 720";
                
                if(strFloat<100)
                    Cell.txtSell.text=@"Bs.F. 6";
                if(strFloat>=100 && strFloat <20840){
                    cost=((strFloat*6)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(strFloat>=20840 )
                    Cell.txtSell.text=@"Bs.F. 1250";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Plata";
                if(pubQtyFloat<600)
                    Cell.txtPub.text=@"Bs.F. 6";
                if(pubQtyFloat>=600 && pubQtyFloat <37000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(pubQtyFloat>=37000)
                    Cell.txtPub.text=@"Bs.F. 370";
                
                if(strFloat<100)
                    Cell.txtSell.text=@"Bs.F. 6";
                if(strFloat>=100 && strFloat <20840){
                    cost=((strFloat*6)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(strFloat>=20840 )
                    Cell.txtSell.text=@"Bs.F. 1250";
                
            }
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Gratis";
                if(strFloat<60)
                    Cell.txtSell.text=@"Bs.F. 6";
                if(strFloat>=60 && strFloat <12500){
                    cost=((strFloat*10)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"Bs.F. %0.2f",cost];
                }
                if(strFloat>=12500 )
                    Cell.txtSell.text=@"Bs.F. 1250";
            }
            
            //Total accounts
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"Bs.F. %0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"Bs.F. %0.2f",(gan/qty)];
            break;
        }
        DEFAULT {
            currency=@"$ ";
            if(indexPath.row==0){
                Cell.txtType.text=@"Oro Premium";
                if(pubQtyFloat<3000)
                    Cell.txtPub.text=@"150";
                if(pubQtyFloat>=3000 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*5)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"650";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
            }
            
            if(indexPath.row==1){
                Cell.txtType.text=@"Oro";
                if(pubQtyFloat<1000)
                    Cell.txtPub.text=@"30";
                if(pubQtyFloat>=1000 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*3)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"390";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
                
            }
            if(indexPath.row==2){
                Cell.txtType.text=@"Plata";
                if(pubQtyFloat<400)
                    Cell.txtPub.text=@"4";
                if(pubQtyFloat>=400 && pubQtyFloat <13000){
                    cost=((pubQtyFloat*1)/100);
                    Cell.txtPub.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(pubQtyFloat>=13000)
                    Cell.txtPub.text=@"130";
                
                if(strFloat<50)
                    Cell.txtSell.text=@"3.25";
                if(strFloat>=50 && strFloat <8462){
                    cost=((strFloat*6.5)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8462 )
                    Cell.txtSell.text=@"550";
                
            }
            
            if(indexPath.row==3){
                Cell.txtType.text=@"Bronce";
                Cell.txtPub.text=@"Gratis";
                if(strFloat<50)
                    Cell.txtSell.text=@"3,25";
                if(strFloat>=50 && strFloat <8500){
                    cost=((strFloat*10)/100);
                    Cell.txtSell.text=[NSString stringWithFormat:@"%0.2f",cost];
                }
                if(strFloat>=8500 )
                    Cell.txtSell.text=@"850";
            }
            CGFloat sell = (CGFloat)[Cell.txtSell.text floatValue];
            CGFloat pub = (CGFloat)[Cell.txtPub.text floatValue];
            CGFloat gan=(qty*strFloat)-(pub)-(sell*qty);
            Cell.txtGan.text=[NSString stringWithFormat:@"%0.2f",gan];
            Cell.txtGanUnit.text=[NSString stringWithFormat:@"%0.2f",(gan/qty)];
            break;
        }
    }
    
    //Images List
    if(indexPath.row==0)
        Cell.imgList.image=[UIImage imageNamed: @"diamond.png"];
    if(indexPath.row==1)
        Cell.imgList.image=[UIImage imageNamed: @"gold.png"];
    if(indexPath.row==2)
        Cell.imgList.image=[UIImage imageNamed: @"plate.png"];
    if(indexPath.row==3)
        Cell.imgList.image=[UIImage imageNamed: @"bronze.png"];
    
    //Valores null en caso de no tener nada aun cargado
    if(self.txtPrice.text==nil || [self.txtPrice.text isEqualToString:@""]){
        Cell.txtSell.text=@"0";
        Cell.txtPub.text=@"0";
        Cell.txtGan.text=@"0";
        Cell.txtGanUnit.text=@"0";
        if([countryCode isEqualToString:@"BR"]){
            self.txtPrice.placeholder=@"Preço";
            self.txtQty.placeholder=@"Quantidade";
            Cell.lblCostPub.text=@"Custo por publicação";
            Cell.lblCostSell.text=@"Custo das vendas";
            Cell.lblGan.text=@"O lucro total";
            Cell.lblGanUnit.text=@"O lucro por unidades";
        }
    }else{
        Cell.txtSell.text=[NSString stringWithFormat:@"%@%@", currency, Cell.txtSell.text];
        Cell.txtPub.text=[NSString stringWithFormat:@"%@%@", currency, Cell.txtPub.text];
        Cell.txtGanUnit.text=[NSString stringWithFormat:@"%@%@", currency, Cell.txtGanUnit.text];
        Cell.txtGan.text=[NSString stringWithFormat:@"%@%@", currency, Cell.txtGan.text];
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtQty resignFirstResponder];
    [self.txtPrice resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
