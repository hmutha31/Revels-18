//
//  FavoritesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class FavoritesPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
