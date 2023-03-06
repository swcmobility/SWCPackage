//
//  ViewController.swift
//  SWCPackageDemo
//
//  Created by Yasheed Muhammed on 06/03/2023.
//

import UIKit
import SWCFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SWCPackage.set(rsaPublicKey: "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAseTQwvuNrVDbbmi9cyucMTj4GizaYzvBhRoArW+sMaE3JtOo7mWNmaAcEYHovr068NG2hh8JkPJurMDp1KLNb9V5r2B9XKsEoTDVlgybcXXITV8im0stknjfVJJ9Djq4mMI805rNyGOTVee9uLtOlhCivzDdJBWLisZ2FkJH2MsFqf0VIuzvPPbLdNjHQOnF9NxKIadgwbGGliciz8fzeveNdLOcCYReOpDzDKFFDjQqTYZF/U4Efsesuh7uEEwoGNL+xdW6R+VavXt/2x1CKmshUEp7socHbxHJHbX5QRB55OfDvfWWK50oDTApdBXogRAbOLTh9AL7L6rlyxvYFQIDAQAB\n-----END PUBLIC KEY-----")

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonAction(_ sender: Any) {
        Task {
            await testFramework()
        }
    }
    func testFramework() async {
        var generator = SWCRequestGenerator(url: "https://smartoffice.dewa.gov.ae/SSMDMZ/token/SSMDR")
        generator.request.body.loginUsername = "yasheed"
        generator.request.body.loginPassword = "test"
        generator.request.body.encryptionType = .rsa
        generator.validateTokenTimeStamp = false
        generator.request.body.moduleId = "M1"
        do {
            let user = try await generator.getResponse(responseType: LoginResponseModel.self)
            print(user)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


public struct LoginResponseModel: Codable {
    let aesKey: String
    let data: LoginDataModel
    let timeStamp: String
    let token: String
    private enum CodingKeys: String, CodingKey {
        case aesKey = "dataValue"
        case data, timeStamp, token
    }
}
public struct LoginDataModel: Codable {
    public let emailId: String?
    public let prNumber: String?
    public let userGuId: String?
    public let designation: String?
    public let designationAr: String?
    public let fullName: String?
    public let fullNameAr: String?
    public let ntId: String?
    private enum CodingKeys: String, CodingKey {
        case emailId, userGuId
        case designation, fullName, ntId, designationAr, fullNameAr
        case prNumber = "pr"
    }
}
