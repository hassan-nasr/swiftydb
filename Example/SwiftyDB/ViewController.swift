//
//  ViewController.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/17/2016.
//  Copyright (c) 2016 Øyvind Grimnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let configuration: Configuration = {
        var configuration = Configuration(databaseName: "database.sqlite")
        
        configuration.dryRun = true
        
        return configuration
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        try? NSFileManager.defaultManager().removeItemAtPath(configuration.databasePath)
        
        let swifty = Swifty(configuration: configuration)
        
        let dogs: [Dog] = (0 ..< 1000).map { _ in Dogger() }
        

        swifty.add(dogs) { result in
            print("Added")
            
            let start = NSDate()
            
            swifty.get(Dog.self) { result in
                print(result.value?.count)
                print("Get:", -start.timeIntervalSinceNow)
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
