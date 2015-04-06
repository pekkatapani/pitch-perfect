//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Pekka Kaariainen on 05/04/15.
//  Copyright (c) 2015 Pekka Kaariainen. All rights reserved.
//

import Foundation
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}