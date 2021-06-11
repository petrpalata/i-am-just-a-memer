//
//  ViewController.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var memeImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let apiClient = MemeGeneratorApiClient()
        async {
            let apiResponse = try? await apiClient.generateMeme("Test", bottomText: "Test")
            guard let apiResponse = apiResponse else {
                print("An error occured during generateMeme call")
                return
            }
            let httpStatusCode = apiResponse.response.statusCode
            print("API Response: \(apiResponse), status: \(httpStatusCode)")
            self.memeImageView?.image = apiResponse.data
        }
    }
    
    
}

