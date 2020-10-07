//
//  ViewController.swift
//  PickerStoryboard
//
//  Created by Bogdan on 14.07.2020.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var enemyHero1: UITextField!
    @IBOutlet weak var enemyHero2: UITextField!
    @IBOutlet weak var enemyHero3: UITextField!
    @IBOutlet weak var enemyHero4: UITextField!
    @IBOutlet weak var enemyHero5: UITextField!
    
    @IBOutlet weak var recomendedHero1: UILabel!
    @IBOutlet weak var buttonShowHeroView: UIButton!
    
    var nameText = ""
    
    var enemyHeroes: [String] = ["", "", "", "", ""]
    /*
    @IBAction func endedEditing(_ sender: UITextField) {
        if sender.text != "" {
            enemyHeroes[sender.tag].append(sender.text!)
        }
    }
    */
    
    // Выводит рекомендуемого героя
    @IBAction func buttonShowHeroPressed(_ sender: UIButton) {
        //self.nameText = enemyHero1.text!
        performSegue(withIdentifier: "hero1name", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! PopUpViewController
        //vc.hero1Name = self.nameText
        
        enemyHeroes[0].append(enemyHero1.text!)
        enemyHeroes[1].append(enemyHero2.text!)
        enemyHeroes[2].append(enemyHero3.text!)
        enemyHeroes[3].append(enemyHero4.text!)
        enemyHeroes[4].append(enemyHero5.text!)
        
        print(enemyHeroes)
        for i in 0...enemyHeroes.count-1 {
            vc.heroNames[i] = enemyHeroes[i]
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

