//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class NetConnection:NSObject {

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
        }

        LogPrint.info(requestString)

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

        var response: NSURLResponse? = nil

        let dataVal: NSData!
        
        do{
            dataVal = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        }catch{
            dataVal = NSData()
        }
        
        //输出返回
        LogPrint.info(NSString(data: dataVal, encoding: NSUTF8StringEncoding))
//        var error: NSError?
        var jsonResult:Dictionary<String, AnyObject>!
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
        }catch{
            jsonResult = Dictionary<String, AnyObject>()
        }


        var httpcode: Int = 0
        if let httpResponse = response as? NSHTTPURLResponse {
            httpcode = httpResponse.statusCode
        }

        var returnResult = Dictionary<String, AnyObject>()
        returnResult[ReturnResult.keyCode] = httpcode
        returnResult[ReturnResult.keyResult] = jsonResult
        return returnResult
    }
}
