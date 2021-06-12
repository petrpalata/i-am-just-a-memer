//
//  ViewController.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import UIKit
import SwiftUI

class MemeGeneratorViewController: UIViewController {
    @IBOutlet weak var memeImageView: UIImageView?
    @IBOutlet weak var topTextField: UITextField?
    @IBOutlet weak var bottomTextField: UITextField?
    @IBOutlet weak var apiFetchIndicator: UIActivityIndicatorView?
    @IBOutlet weak var selectedMemeLabel: UILabel?

    let apiClient = MemeGeneratorApiClient()
    
    var selectedMeme: Meme?
    
    @IBAction func generateMemePressed() {
        toggleLoading()
        
        async {
           guard let apiResponse = try? await fetchGeneratedMeme() else {
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
    
    @IBAction func pickAMemePressed() {
        let viewModel = MemeTypeViewModel()
        viewModel.delegate = self
        let hostingViewController = UIHostingController(
            rootView: MemeTypePickerView(viewModel: viewModel)
        )
        present(hostingViewController, animated: true)
    }
    
    @MainActor
    private func fetchGeneratedMeme() async throws -> (data: UIImage, response: HTTPURLResponse) {
        let topText = topTextField?.text ?? ""
        let bottomText = bottomTextField?.text ?? ""
        
        if let selectedMeme = selectedMeme,
           let imageUrl = selectedMeme.imageUrl {
            return try await apiClient.generateMeme(imageUrl, topText: topText, bottomText: bottomText)
        }
        return try await apiClient.generateMeme(topText, bottomText: bottomText)
    }
    
    private func toggleLoading() {
        apiFetchIndicator?.isHidden.toggle()
        memeImageView?.isHidden.toggle()
    }
}

extension MemeGeneratorViewController: MemeTypeViewModelDelegate {
    func didSelectMeme(_ meme: Meme?) {
        selectedMeme = meme
        if let name = meme?.name {
            selectedMemeLabel?.text = "Meme selected: \(name)"
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

