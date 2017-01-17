//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class NetConnection:NSObject {
    
    static let logTag = "NetConnection"

    //MARK:发送请求
    class func sendRequest(urlPath: String, method: String, params: Dictionary<String, String?>?, headParams: Dictionary<String, String?>?) -> Dictionary<String, AnyObject> {


        //输出参数
        LogPrint.info("urlpath:\(urlPath),headParams:\(headParams),params:\(params)")

        let removedEmptyParams = Utils.removeEmptyParmas(params)
        let removedEmptyHeadParms = Utils.removeEmptyParmas(headParams)


        //生成请求参数
        var requestString: String = ""
        for (key, value) in removedEmptyParams {
            requestString += key + "=" + value!.urlEncode + "&"
        }

        //生成请求url
        var requestUrl = ""
        if method == "POST" { 
            requestUrl = urlPath
        } else if method == "GET" {
            requestUrl = urlPath + "?" + requestString
            
              LogPrint.info("getUrl:\(requestUrl)")
        }

      

        let url: NSURL = NSURL(string: requestUrl)!

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method

        //set httpbod
        if method == "POST" {
            request.HTTPBody = requestString.dataUsingEncoding(NSUTF8StringEncoding)
        }

        //set head params
        if headParams != nil {
            for (key, value) in removedEmptyHeadParms {
                request.addValue(value!, forHTTPHeaderField: key)
            }
        }

        request.addValue(Config.userAgent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = Config.connectTimeOut
       
        return NetConnection.sendRequest(request)
    }
    
    //MARK:发送请求
     class func sendRequest(request:NSMutableURLRequest)  -> Dictionary<String, AnyObject> {
        var response: NSURLResponse? = nil
        var jsonResult:Dictionary<String, AnyObject>!
        var httpcode: Int = 0
        var dataVal: NSData? = nil
        
        do{
            dataVal = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                httpcode = httpResponse.statusCode
            }
            
        }catch(let e){
            
            LogPrint.error(NetConnection.logTag,e)
            
            if let error = e as? NSError {
                if error.code == NSURLErrorTimedOut {
                    httpcode = HTTPStatusCode.RequestTimeout.rawValue
                }
            }

        }
        
        if dataVal != nil {
            do{
                //输出返回
                LogPrint.info(NSString(data: dataVal!, encoding: NSUTF8StringEncoding))
                jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
            }catch(let e){
                LogPrint.error(logTag,e)
            }
            
        }
        
        var returnResult = Dictionary<String, AnyObject>()
        returnResult[ReturnResult.keyCode] = httpcode
        returnResult[ReturnResult.keyResult] = jsonResult
        return returnResult
 
    }
}
