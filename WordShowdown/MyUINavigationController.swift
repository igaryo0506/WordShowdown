//
//  MyUINavigationViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.backgroundColor = UIColor{_ in return #colorLiteral(red: 0, green: 0.7262094617, blue: 0.6250674725, alpha: 1)}
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "←",
            style: .plain,
            target: nil,
            action: nil
        )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
