//
//  ViewController.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import UIKit

class MemeGeneratorViewController: UIViewController {
    @IBOutlet weak var memeImageView: UIImageView?
    @IBOutlet weak var topTextField: UITextField?
    @IBOutlet weak var bottomTextField: UITextField?
    @IBOutlet weak var apiFetchIndicator: UIActivityIndicatorView?

    let apiClient = MemeGeneratorApiClient()

    @IBAction func generateMemePressed() {
        let topText = topTextField?.text ?? ""
        let bottomText = bottomTextField?.text ?? ""
        
        toggleLoading()
        
        async {
            let apiResponse = try? await apiClient.generateMeme(topText, bottomText: bottomText)
            guard let apiResponse = apiResponse else {
                print("An error occured during generateMeme call")
                toggleLoading()
                return
            }
            
            let httpStatusCode = apiResponse.response.statusCode
            print("API Response: \(apiResponse), status: \(httpStatusCode)")
            
            memeImageView?.image = apiResponse.data
            toggleLoading()
        }
    }
    
    private func toggleLoading() {
        apiFetchIndicator?.isHidden.toggle()
        memeImageView?.isHidden.toggle()
    }
}

