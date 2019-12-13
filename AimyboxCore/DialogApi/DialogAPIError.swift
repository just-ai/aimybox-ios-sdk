//
//  DialogAPIError.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation


public enum DialogAPIError: Error {
    /**
     
     */
    case requestTimeout
    /**
     
     */
    case requestCancellation
    /**
    
    */
    case clientSide(Error)
}
