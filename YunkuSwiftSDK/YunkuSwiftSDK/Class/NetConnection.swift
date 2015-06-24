//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class NetConnection:NSObject {

    class func sendRequest(urlPath: String, method: String, params: Dictionary<String, String?>?, headParams: Dictionary<String, String?>?) -> Dictionary<String, AnyObject> {


        //输出参数
        LogPrint.info("urlpath:\(urlPath),headParams:\(headParams),params:\(params)")

        var removedEmptyParams = Utils.removeEmptyParmas(params)
        var removedEmptyHeadParms = Utils.removeEmptyParmas(headParams)


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

        var url: NSURL = NSURL(string: requestUrl)!

        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method

        //set httpbod
        if method == "POST" {
            request.HTTPBody = requestString.dataUsingEncoding(NSUTF8StringEncoding)
        }

        //set head params
        if headParams != nil {
            for (key, value) in removedEmptyHeadParms {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        request.addValue(Config.userAgent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = Config.connectTimeOut

        var response: NSURLResponse?

        var dataVal: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)!

        //输出返回
        LogPrint.info(NSString(data: dataVal, encoding: NSUTF8StringEncoding))
        var error: NSError?
        var jsonResult:Dictionary<String, AnyObject>! = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: &error) as? Dictionary<String, AnyObject>


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
