//
//  WebServices.swift
//  Desidime
//
//  Created by Nitesh Ahuja on 07/02/18.
//
//

import UIKit

protocol WebServiceDelegate: class {
    func webserviceCallFinishedWithSuccess(_ success:Bool,responseObj:NSDictionary,serviceTag:String)
}

class WebServices: NSObject
{
    weak var delegate:WebServiceDelegate?
    
    func callSimpleWebService(_ url:String, method:String,serviceTag:String)
    {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let strUrl = NSString(format:"%@",url)
        let URL = NSURL(string:strUrl as String)
        let request = NSMutableURLRequest(url: URL! as URL)
        request.addValue("7d7c5cacb355d043f07c7c9e4b38257ea5683f8d643b578683877a9b6a8bee1b", forHTTPHeaderField: "X-Desidime-Client")
        request.httpMethod = method
        
        let task =  session.dataTask(with: request as URLRequest, completionHandler: {(data,response, error) -> Void in

            if error == nil
            {
                do{
                    let resposneData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    self.delegate?.webserviceCallFinishedWithSuccess(true, responseObj:resposneData as! NSDictionary,serviceTag: serviceTag)
                }
                catch{}
            }
            else
            {
               // print(error?.localizedDescription)

                self.delegate?.webserviceCallFinishedWithSuccess(false, responseObj:[error?.localizedDescription:"error"],serviceTag: serviceTag)
            }
        })
        task.resume()
    }
}
