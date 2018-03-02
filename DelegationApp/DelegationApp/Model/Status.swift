//
//  Status.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/12/18.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import Foundation

class Status {
    public var status: Bool
    public var message: String = ""
    public var http: HTTPStatus = HTTPStatus()
    
    init(_ status: Bool) {
        self.status = status
    }
    
    init(_ status: Bool, _ msg: String) {
        self.status = status
        self.message = msg
    }
    
    init(http: Int) {
        if 0 <= http && http < 400 {
            self.status = true
        } else {
            self.status = false
        }
        
        self.http = HTTPStatus(http)
        self.message = self.http.description
    }
}

class HTTPStatus {
    public var code: Int = 0
    public var message: String = ""
    public var description: String = ""
    
    init() {
        self.code = 0
        self.message = self.httpLookupMessage(from: 0)
        self.description = self.httpLookupDescription(from: 0)
    }
    
    init(_ code: Int) {
        self.code = code
        self.message = self.httpLookupMessage(from: code)
        self.description = self.httpLookupDescription(from: code)
    }
    
    private func httpLookupMessage(from code: Int) -> String {
        if let res = HTTPStatusCodes.statusCodes[String(code)] {
            return res["message"] ?? "Unknown"
        } else {
            return "Unknown"
        }
    }
    
    private func httpLookupDescription(from code: Int) -> String {
        if let res = HTTPStatusCodes.statusCodes[String(code)] {
            return res["description"] ?? "Unknown"
        } else {
            return "Unknown"
        }
    }
    
    private class HTTPStatusCodes {
        public static let statusCodes: [String: [String: String]] = [
            "0": [
                "message": "NONE",
                "description": "None"],
            
            "100": [
                "message": "HTTP_CONTINUE",
                "description": "The server has received the request headers, and the client should proceed to send the request body"],
            
            "101": [
                "message": "HTTP_SWITCHING_PROTOCOLS",
                "description": "The requester has asked the server to switch protocols"],
            
            "103": [
                "message": "HTTP_CHECKPOINT",
                "description": "Used in the resumable requests proposal to resume aborted PUT or POST requests"],
            
            "200": [
                "message": "HTTP_OK",
                "description": "The request is OK"],
            
            "201": [
                "message": "HTTP_CREATED",
                "description": "The request has been fulfilled, and a new resource is created"],
            
            "202": [
                "message": "HTTP_ACCEPTED",
                "description": "The request has been accepted for processing, but the processing has not been completed"],
            
            "203": [
                "message": "HTTP_INFORMATION",
                "description": "The request has been successfully processed, but is returning information that may be from another source"],
            
            "204": [
                "message": "HTTP_NO_CONTENT",
                "description": "The request has been successfully processed, but is not returning any content"],
            
            "205": [
                "message": "HTTP_RESET_CONTENT",
                "description": "The request has been successfully processed, but is not returning any content, and requires that the requester reset the document view"],
            
            "206": [
                "message": "HTTP_PARTIAL_CONTENT",
                "description": "The server is delivering only part of the resource due to a range header sent by the client"],
            
            "300": [
                "message": "HTTP_MUTLIPLE_CHOICES",
                "description": "A link list. The user can select a link and go to that location. Maximum five addresses"],
            
            "301": [
                "message": "HTTP_MOVED_PERMANENTLY",
                "description": "The requested page has moved to a new URL"],
            
            "302": [
                "message": "HTTP_FOUND",
                "description": "The requested page has moved temporarily to a new URL"],
            
            "303": [
                "message": "HTTP_SEE_OTHER",
                "description": "The requested page can be found under a different URL"],
            
            "304": [
                "message": "HTTP_NOT_MODIFIED",
                "description": "Indicates the requested page has not been modified since last requested"],
            
            "307": [
                "message": "HTTP_TEMPORARY_REDIRECT",
                "description": "The requested page has moved temporarily to a new URL"],
            
            "308": [
                "message": "HTTP_RESUME_INCOMPLETE",
                "description": "Used in the resumable requests proposal to resume aborted PUT or POST requests"],
            
            "400": [
                "message": "HTTP_BAD_REQUEST",
                "description": "The request cannot be fulfilled due to bad syntax"],
            
            "401": [
                "message": "HTTP_UNAUTHORIZED",
                "description": "The request was a legal request, but the server is refusing to respond to it. For use when authentication is possible but has failed or not yet been provided"],
            
            "403": [
                "message": "HTTP_FORBIDDEN",
                "description": "The request was a legal request, but the server is refusing to respond to it"],
            
            "404": [
                "message": "HTTP_NOT_FOUND",
                "description": "The requested page could not be found but may be available again in the future"],
            
            "405": [
                "message": "HTTP_METHOD_NOT_ACCEPTED",
                "description": "A request was made of a page using a request method not supported by that page"],
            
            "406": [
                "message": "HTTP_NOT_ACCEPTABLE",
                "description": "The server can only generate a response that is not accepted by the client"],
            
            "407": [
                "message": "HTTP_PROXY_AUTHENTICATION_REQUIRED",
                "description": "The client must first authenticate itself with the proxy"],
            
            "408": [
                "message": "HTTP_REQUEST_TIMEOUT",
                "description": "The server timed out waiting for the request"],
            
            "409": [
                "message": "HTTP_CONFLICT",
                "description": "The request could not be completed because of a conflict in the request"],
            
            "410": [
                "message": "HTTP_GONE",
                "description": "The requested page is no longer available"],
            
            "411": [
                "message": "HTTP_LENGTH_REQUIRED",
                "description": "The \"Content-Length\" is not defined. The server will not accept the request without it "],
            
            "412": [
                "message": "HTTP_PRECONDITION_FAILED",
                "description": "The precondition given in the request evaluated to false by the server"],
            
            "413": [
                "message": "HTTP_REQUEST_ENTRY_TOO_LONG",
                "description": "The server will not accept the request, because the request entity is too large"],
            
            "414": [
                "message": "HTTP_REQUEST_URI_TOO_LONG",
                "description": "The server will not accept the request, because the URL is too long. Occurs when you convert a POST request to a GET request with a long query information "],
            
            "415": [
                "message": "HTTP_UNSUPPORTED_MEDIA_TYPE",
                "description": "The server will not accept the request, because the media type is not supported "],
            
            "416": [
                "message": "HTTP_REQUESTED_RANGE_NOT_SATISFIABLE",
                "description": "The client has asked for a portion of the file, but the server cannot supply that portion"],
            
            "417": [
                "message": "HTTP_EXPECTATION_FAILED",
                "description": "The server cannot meet the requirements of the Expect request-header field"],
            
            "500": [
                "message": "HTTP_INTERNAL_SERVER_ERROR",
                "description": "A generic error message, given when no more specific message is suitable"],
            
            "501": [
                "message": "HTTP_NOT_IMPLEMENTED",
                "description": "The server either does not recognize the request method, or it lacks the ability to fulfill the request"],
            
            "502": [
                "message": "HTTP_BAD_GATEWAY",
                "description": "The server was acting as a gateway or proxy and received an invalid response from the upstream server"],
            
            "503": [
                "message": "HTTP_SERVICE_UNAVAILABLE",
                "description": "The server is currently unavailable (overloaded or down)"],
            
            "504": [
                "message": "HTTP_GATEWAY_TIMEOUT",
                "description": "The server was acting as a gateway or proxy and did not receive a timely response from the upstream server"],
            
            "505": [
                "message": "HTTP_VERSION_NOT_SUPPORTED",
                "description": "The server does not support the HTTP protocol version used in the request"],
            
            "511": [
                "message": "HTTP_NETWORK_AUTHENTICATION_REQUIRED",
                "description": "The client needs to authenticate to gain network access"]
        ]
    }
}
