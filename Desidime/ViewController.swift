//
//  ViewController.swift
//  Desidime
//
//  Created by Nitesh Ahuja on 07/02/18.
//  Copyright © 2018 Nitesh Ahuja. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate{
    
    @IBOutlet var btnTop:UIButton!
    @IBOutlet var btnPopular:UIButton!
    
    @IBOutlet var tblProduct:UITableView!
    
    @IBOutlet var Indicatorview:UIActivityIndicatorView!

    var arrProduct = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Indicatorview.hidesWhenStopped = true
        
        Indicatorview.startAnimating()
        Indicatorview.isHidden = false

        getCategory(url:TOPDEAL_URL)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBACTION METHOD

    @IBAction func btnHeadreAction(sender:UIButton)
    {
        let Cbg = UIColor(red: 46.0/255.0, green: 148.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        if (sender.tag == 1001)
        {
            btnTop.setTitleColor(UIColor.white, for: .normal)
            btnPopular.setTitleColor(UIColor.black, for: .normal)
            
            btnTop.backgroundColor = Cbg
            btnPopular.backgroundColor = UIColor.white
            
            Indicatorview.startAnimating()
            Indicatorview.isHidden = false
            getCategory(url:TOPDEAL_URL)
        }
        else
        {
            btnTop.setTitleColor(UIColor.black, for: .normal)
            btnPopular.setTitleColor(UIColor.white, for: .normal)
            
            btnTop.backgroundColor = UIColor.white
            btnPopular.backgroundColor = Cbg
            
            Indicatorview.startAnimating()
            Indicatorview.isHidden = false
            getCategory(url:POPULARDEAL_URL)
            
        }
    }
    
    //MARK:- TABLEVIEW METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        
        let imgPro = cell?.contentView.viewWithTag(1) as! UIImageView
        let lblTitle  =  cell?.contentView.viewWithTag(2) as! UILabel
        let lblDesc =  cell?.contentView.viewWithTag(3) as! UILabel
        
        let lblMsg = cell?.contentView.viewWithTag(4) as! UILabel
        let lblShare = cell?.contentView.viewWithTag(5) as! UILabel
        let lblshop = cell?.contentView.viewWithTag(6) as! UILabel
        let lblprice = cell?.contentView.viewWithTag(7) as! UILabel

        if arrProduct.count > 0
        {
            let dic = arrProduct.object(at: indexPath.row) as! NSDictionary

            let strImage = dic.value(forKey: "image") as! NSString
            let imgUrl = NSURL(string: strImage as String)
            imgPro.sd_setImage(with: imgUrl as URL?, completed: nil)
            
            lblTitle.text = dic.value(forKey: "title") as? String
            
            let desc = dic.value(forKey: "description") as? NSString
            if desc != nil
            {
                lblDesc.text = desc! as String
            }
            else
            {
                 lblDesc.text = ""
            }
            let msgcount = dic.value(forKey: "comments_count") as? NSInteger
            lblMsg.text = NSString(format:"%ld",msgcount!) as String
            
            let userdic = dic.value(forKey: "user") as! NSDictionary
            let sharecount = userdic.value(forKey: "current_dimes") as? NSInteger

            lblShare.text = NSString(format:"%ld",sharecount!) as String
            
            let proprice = dic.value(forKey: "current_price") as? NSInteger

            lblprice.text = NSString(format:"%ld",proprice!) as String
            
            let merdic = dic.value(forKey: "merchant") as! NSDictionary

            lblshop.text = merdic.value(forKey: "name") as? String
            
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150.0
    }
    
    //MARK:- API CALL METHOD

    func getCategory(url:String)
    {
        let ser_signin = WebServices()
        ser_signin.delegate = self
        
        ser_signin.callSimpleWebService(url as String, method:"GET",serviceTag: "get_cat")
      
    }
    
    internal func webserviceCallFinishedWithSuccess(_ success: Bool, responseObj: NSDictionary, serviceTag: String)
    {
        OperationQueue.main.addOperation {
            self.Indicatorview.stopAnimating()
            self.Indicatorview.isHidden = true
            if success
            {
                if serviceTag == "get_cat"
                {
                    let dicdate = responseObj.value(forKey: "deals") as! NSMutableDictionary
                    
                    let arrdata = dicdate.value(forKey: "data") as? NSMutableArray
                    if (Double((arrdata?.count)!) > 0)
                    {
                        self.arrProduct = arrdata!
                        self.tblProduct.reloadData()
                        
                        self.Indicatorview.stopAnimating()
                        self.Indicatorview.isHidden = true
                        
                    }
                }
                
            }
            else
            {
                
            }
               
            }
        }
 
    
}

