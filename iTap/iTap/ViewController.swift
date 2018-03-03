//
//  ViewController.swift
//  iTap
//
//  Created by Fedor Sheremetyev on 03/03/2018.
//  Copyright © 2018 Elizaveta Sheremetyeva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var textView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func buzz(_ sender: UIButton) {
    textView.insertText("hello\n")
  }
}

