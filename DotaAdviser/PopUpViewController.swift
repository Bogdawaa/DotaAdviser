//
//  PopUpViewController.swift
//  PickerStoryboard
//
//  Created by Bogdan on 13.08.2020.
//  Copyright © 2020 Bogdan. All rights reserved.
//


import Foundation
import UIKit
import Kanna
import Alamofire

class PopUpViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroesShowTableView.delegate = self
        heroesShowTableView.dataSource = self
        self.scrapeDotaHeroes()
        
        print("heronames[0] is: \(heroNames[0])")
        //print("heronames[1] is: \(heroNames[1])")
        heroesMid.append(contentsOf: self.scrapeDotaHeroesMid(name: heroNames[0]))
        heroesFullSupport.append(contentsOf: self.scrapeDotaHeroesMid(name: heroNames[1])) 
        heroesCarry.append(contentsOf: self.scrapeDotaHeroesMid(name: heroNames[2]))
        heroesSupport.append(contentsOf: self.scrapeDotaHeroesMid(name: heroNames[3]))
        heroesFullSupport.append(contentsOf: self.scrapeDotaHeroesMid(name: heroNames[4]))
        
        finalArray = heroesMid + heroesFullSupport + heroesSupport + heroesCarry + heroesOfflane
        
        print("finalArray in did load: \(finalArray)")
        print("final mid arr:\(heroesMid)")
        print("final offlane arr:\(heroesOfflane)")
        print("final sup4 arr:\(heroesSupport)")
        print("final sup5 arr:\(heroesFullSupport)")
        print("final core arr:\(heroesCarry)")
        
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var heroes: [String] = []
    var heroesSupport: [String] = []
    var heroesFullSupport: [String] = []
    var heroesMid: [String] = []
    var heroesCarry: [String] = []
    var heroesOfflane: [String] = []
    
    var heroNames: [String] = ["", "", "", "", ""]
    
    var goodVs: [String] = []
    var tmpArray: [String] = []
    
    var finalArray: [String] = []
    
    var textCellIdentifier = "ShowCell"

    @IBOutlet var heroesShowTableView: UITableView!
    @IBOutlet weak var buttonBackView: UIButton!
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //finalArray = selectHeroes(arr1: heroesMid, arr2: heroesCarry, arr3: heroesOfflane, arr4: heroesSupport, arr5: heroesFullSupport)
        //return goodVs.count
        return tmpArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)

        let row = indexPath.row
        cell.textLabel?.text = tmpArray[row]
        return cell
    }
        
    func scrapeDotaHeroes() -> Void {
        AF.request("https://ru.dotabuff.com/heroes").responseString { response in
                switch response.result {
                    case let .success(value):
                            print("Success")
                            if let html = response.value {
                                self.parseHTML(html: html)
                            }
                    case let .failure(error):
                        print("Response failure")
                }
            }
        }
    
    var arr = ["arr"]
    var arrName: [String] = []
    
    func scrapeDotaHeroesMid(name: String) -> [String] {
        AF.request("https://ru.dotabuff.com/heroes/\(name)").responseString { response in
                switch response.result {
                    case let .success(value):
                            print("Success")
                            if let htmlMid = response.value {
                                //self.parseHTML2(html: htmlMid)
                                self.arrName.append(contentsOf: self.parseHTML2(html: htmlMid))
                            }
                    case let .failure(error):
                        print("Response failure")
                }
            }
        print ("inside scrape func: \(arrName)")
        return arrName
        }
    
    func parseHTML(html: String) -> Void {
            if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                for hero in doc.css("div[class='hero']") {
                    let heroesString = hero.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        heroes.append(heroesString)
                        //print("\(heroesString)\n")
                }
            }
            if let docMid = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                for heroMid in docMid.css("a[class='link-type-hero']") {
                    let heroesMidString = heroMid.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        goodVs.append(heroesMidString)
                        print("\(heroes[0]) is good vs: \(heroesMidString)\n")
                }
            }
            self.heroesShowTableView.reloadData()
        }
    
    func parseHTML2(html: String) -> [String] {
        var supertmp: [String] = []
        if let docMid = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for heroMid in docMid.css("a[class='link-type-hero']") {
                let heroesMidString = heroMid.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    supertmp.append(heroesMidString)
                    self.tmpArray.append(heroesMidString)
                print("Heroes mid: \(heroNames[0]) is good vs: \(heroesMidString)\n")
                }
        }
        print("final array is: \(tmpArray)")
        print("arr is: \(arr)")
        self.heroesShowTableView.reloadData()
        return supertmp
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func refresh() {
        finalArray = uniq(source: finalArray)
        finalArray = finalArray.sorted(by: <)
        self.heroesShowTableView.reloadData()
    }
}
