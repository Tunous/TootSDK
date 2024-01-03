//
//  WebPushMessageEncryptionTests.swift
//
//
//  Created by Łukasz Rutkowski on 30/12/2023.
//

import Foundation
import XCTest
import TootSDK
import Crypto

final class WebPushMessageEncryptionTests: XCTestCase {
    func testDecrypt() throws {
        let encryptedMessage = try decode("6nqAQUME8hNqw5J3kl8cpVVJylXKYqZOeseZG8UueKpA")
        let privateKeyData = try decode("9FWl15_QUQAWDaD3k3l50ZBZQJ4au27F1V4F0uLSD_M")
        let privateKey = try P256.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData)
        let serverPublicKeyData = try decode("BNoRDbb84JGm8g5Z5CFxurSqsXWJ11ItfXEWYVLE85Y7CYkDjXsIEc4aqxYaQ1G8BqkXCJ6DPpDrWtdWj_mugHU")
        let serverPublicKey = try P256.KeyAgreement.PublicKey(x963Representation: serverPublicKeyData)
        let auth = try decode("R29vIGdvbyBnJyBqb29iIQ")
        let salt = try decode("lngarbyKfMoi9Z75xYXmkg")

        let decryptedMessageData = try WebPushMessageEncryption.decrypt(
            encryptedMessage,
            privateKey: privateKey,
            serverPublicKey: serverPublicKey,
            auth: auth,
            salt: salt
        )
        let decryptedMessage = try XCTUnwrap(String(data: decryptedMessageData, encoding: .utf8))
        XCTAssertEqual(decryptedMessage, "I am the walrus")
    }

    func testAuthSecretLength() throws {
        let authSecret = WebPushMessageEncryption.Keys.newAuthSecret()
        XCTAssertEqual(authSecret.count, 16)
    }

    func testDecryptAndDecode() throws {
        let encryptedMessage = try decode("1mtzCY8_OC9vLMEgmWmw04lkNv3sTesdF7qkk3v15jdlpsXFCi72l0ozKghHvwmj9V_i6Z9oUI_BXPmBPd-plSOSKkoM2TudyCJSac2MSZ09OURlOmwV-KXgHnU2FzFjhTuSxAICCnzrt0MIiYf2zU3Sr2l7bD0QSTCPDfI6vgE70ngiqp6mK1y0sk1bhNZTTBECJEArk3BsFu_pTRT1eB1f-Y6Nvli_lj19fxGpn-uWAM0vLDyN6Xa896SNvGDofDbFfd5iYsUiygojLsSNLqQx_tsNI76owdMiXHgoqMp2nKROvFrN3ar58unUnrTDF7rkf7j0meEygzwDrLa2eE7bhrFTMqwkhMCDxL8YiZ4AXq2Dr-r6DdvpugFxKnRQo4pID4GAP13ru4HwhPatO_VynXjJL4XovtvROGzo81iuU8jyOzc4Et06KGjKphAlRhKXEvgK6IV2ORxLgLe-9IJHpIpGACwMfZndUk3viPbt6ol1QZw1cs7owf5XSjNKPzTms1c1yMKKaVViuxcvNO2qt_xk7bQ6B0bzTBrgmmspVxOGm9XhKKhwt2sIAH6CTHOct0r2-P69VlC-A6EaipTK9NOY-yv8mU3PrC7Q3Yja4amxDdOLSu6j9eTeOi6thYDf6HMQYaSd73fU8NUe6fvpp_L9HiQDC3eFqMEfXYvwiPRbmBHLpQTHzlJmmLFR1h-HaHxkER3kQiDyK11Uu0bajWBB4ce_vXBVTHdvFcc3SBLjgBeVZh4IVFY69hHX03-VLmCE5flTEZmb4yA-2P9HAj2aLTLlajPZSKuJnQHeYn69IG418VPyjzQfiAQ_yL1TmiwXHGXHsp6TlAaUG7ueGAhzsdSr_sc5SVDmszmfgPANbOS-Jvc78LxxTH054z-AwXT5P4tPm91dYKpDxS5s5MmjUsTY2VS4YkFkrcABQrkAsSPZCBrALlD46niO2zBNUZwqKIz_YM-5Lw2l8F0eX5zFvqKfViZU52qxfzJsloXM5hL7j0GQw3G5MGpPUJ_0dOUl1vg8fibGaJhl2ncffJNktD4sC3po-q43L0GpGSe-wFaO_1_Lc7TnC4BcJz_HKwdHwPLHPUJB7UMWTZdkOo0ezqBb40qigeS_162GFwJB4p6gKWvekYpBSZkWEHRpDxe_TM8TfZPHr7BE1PsVoZiplCQhmgM2wKnTGq1I4C7WqWkr0FmNHd3lQpjOtBr3MjAXxTmF9Gd_B727f5xv3a0LdmjKwrEPxuMeT8OHiDVUUwt4ZNk7wK3ugWyjyMTvvJL5dMbDrSm8d27Aq2zRL5bkGw9HBXZ_fzsaK0zC21_tNEFCHoP9eEwnlQsb_5ZUxnK9CZY9PlTtDzU65aD0nOuXVuOSYaQOKVMaR052SCL5Oo5i85ZvwVPZRrue1fO1V6hQAYi3qXRxiX4ndbBtLq8NMb8zqljW7DcLzkEbC0GeQR2LMj7fMwWU8lbqBiBSrLjA-Ob7Vghi9ZBkjUaBLdS1G0MJ96bOmDjyRBap3EOdPjEgmfA_WrdW3z7i2vkdp3iHoy63vEWVIgxXoC4Xy-rdvzrASYDzFx3SYEU7szaIToZGX-mFcH2AJgsSVF6S1b3vVSoH1B1kZ86S__DkvbDzJE0C-VBomPBmOhGNihz2ZNHpS5zbbLXEMiYAXijD76w9uzwJ9p5x8m3EPDE3XNjimxt33dQasj-TGwSCihKnyLDKLeyqH_zC82lEztBdfWnBs-RpxvbP1tPwkh-9qwYtNYJYW_dTgX7WETOuZxexpOZBIvMON5_QDqaQfuQDd6AP3ptciSSHDdVGnhGolSiIzgcxSTGYhLJl6Y_0aAq8DSOSzAprxJH9Nfuw9KwgofnkEdKIALuN0ogMvdWqA85u2f0k7GSU9YGaISeZF0lwef0OlSO914jKt_U4pt_sQXzJPViGcgYHpo1Rdw0lckYSij8ycreHNT-U6qIF11oKO0ANBCgqh77P7IxgyXR2X7FZX_b9R_uv_XmR6YuVdTOABfpynACqDfWcXV4ANyzuRolGty-OR9HL_YRu1TRsrE_vdGqeGn3rZdk0CGlyQ0erHBfW4IGIqfuQ5ED_ka4fTwYay-S1uUwjsy2pfMNrb--jzuLwQmKe03X8pY4OsPTZj0yDGOhgO2v2CGjoxMvRDn7YSxvdiopTsDxAaWrJcItLQg5PCIPjnSBwHyzlJz7eWIv6-kTkvjPU30yo79KVj-4KSVZxRQtjXzVNMDvrh0vz_nwoFE42R1jDyFJG4nqIM8gXdPPkeuGMPmuqkantc7nvDJdi7bhXECCpvjH_YOPCIwnZ1J0t4i0HFTW2gBIrkRvrj4VLWCqzJ1yn_YUXoFruzxbv2MXwFVqr5MSciqOotot-pQnHO23FrgUbRQuBO-N0XsgUBxV_xWuAAREUWL4mrHoUCZAfmyCeDXfBMfF3gH9tnyJS17DzRjTKo8rf88SReR08O1N-xAZftbNQ66xvXWrgHFGhhlBcH3vrc5nDCu_6Oz0TI83sLug0MnKxxBgEhbcMvTp0dDwZRRBXpOGSri_u4snIM504W5swiEjvhE0jsEV9k67_Qo4aukvG9CLwbvDggLOn4OkHwIlgKHvMSXYuc5x1T_i4RHce0R89e83tfF0PBodMw3F4vx18Ca8nUAOVsNNMhpcN2Y2GnSjL5wf6cCJHRbVDPWmLfhjoyl5rIbT8X3LSFVUq4EDrgn-JLTsDFdCuKZOeX9o6A8Y6pz3Z6mY0QwIvlkHAHmKbFyjlDM879Jy5Bp90SfE8W9bKXj1HNFTm86Ks2_1K8ozcyF8Ge48mSOnK5gU7ChpNj5XwaH38Al6xJ1CLoWQ9H8KVMwEkd5nu5-iED-2OdzyRksNOJS-u7IKSv3VugGmIzG-0xW9z0uebiZxMYVo1_IEeDN497-V7oNXMHj9GLa00l1GzxfHFhrU1S5T6vrB7BrVq5Z9p2rj9DAFBAUvnOIBOiSVFDyqb9kJVXmuY9jJGJLbV1MNBCkhm7N-LkOGYK0tSfVGd8vDf-eFJBhpUwmum4ASLnoc4ZB_NIDbZ4TdkAIJuxRpneBysnkfo5jmcvFxD7XFE-k_Lo609lO942__3-erYEsgBwZcFXxYlfSqwqCIwn3_h-OaUndV_2QmUolRHtv9fNVuWo7QXCTEOSRfnWHH2sLPL7HPBK-pYh-SXZUTEsDiN7DjvLIthHtj6swwnDw56platJ71aTG79R5QA3jW6aj9EgS-iOTtz9Qh9WBsNshSgwJAsfC67cO8e4Pbt4f8KX1YUgGQRzkE9oF4NffokI6S2G7A1hArGvJG9QGAIEZHieouxOYw7lIDiIy1D8NeM4L88MZ_x95qoVkkCljVWE3bgIWyeVQhqa9F_ZQ9jPMKab0h0-rla3g5xozVlb7OJg3r60ObD9XPFG6qc1BBiP7UfP14kpn3YmaumbTd5EUWQule9NJtVHFTEF9YH5Seqjcp9MBBAMKIBVhGyLsRp9Va6XVMyuMhtvViw3POs8fjtxOG6cMXvLw4LT0vaUVidgrcfsqzvnnusC-dmEDW8HgZoinq13-o9sMh1gI_VrGP5f1muEqFP-SFrI3OF_LEiiGygqxiueNzzTJVWqAzpOgV5t53j6ilJgp3F3hwS1OYFUEsajmLa6uC666I0Hqoa5-FG17EogWmc_JIO92kZxR4Qa4lccklzGZhvHxltx5IRNUcMieMNSQ2IOxkkoI397XC584OHh8V-JgijhG6DWKBdgejE1LUfYouPnIxr7Mm-5a-NCVB1uq90hoyBSkltedIyCK-4CXxwXl0AOFIwlHjD2z_JDq74qygRCLuBBSob6JyFFaF8FPjBgf5HgUTQcHlat4eU4yDllSHw2bCgMg4X1B_Sttcb6dN1oOreITv5JWsGIxv_XM44KUTHqNu7x0Z4dDyPqbwK5j51rSpM2q-n-qAYoqdoMLikuBXe7ThTohXLwtd3GAQGNJesz1Ch6CbSiLdjqQWtTZ3_06mxHXPlQUJMIjasewEFWfdNIsCJj6QUp_xD2kiy4wzjbqdPXXX-NHqylKNvie4JoCOLweNaYLP12tuFByPH_uhCE6QP0w")
        let privateKeyData = try decode("BF1sQLyEbj_Q2w9Gr7CxULMW0dXT5ieNqfNW_SHnilFLf938diBugHck3W2xf3dTUC93J0yPv8_a79qQ-AbfStlVgbJLWlzK4MFXqFGJRYX6wVOoHsmRr36B11LrtN0dJQ")
        let privateKey = try P256.KeyAgreement.PrivateKey(x963Representation: privateKeyData)
        let serverPublicKeyData = try decode("BFbMjBuONvogk0Z5gdaPYx1hshYTfoc7eoMHjaPpGspYTfzdba8KMaXJGew63nD7S9ttnGl-hys_VlTxjnGUCZQ")
        let serverPublicKey = try P256.KeyAgreement.PublicKey(x963Representation: serverPublicKeyData)
        let auth = try decode("ouXXmgTzIc17NYAqxZw8Yw")
        let salt = try decode("2tTt38nDpGXNKXTCRydTLg")

        let pushNotification = try WebPushMessageEncryption.decryptAndDecodePush(
            encryptedMessage,
            privateKey: privateKey,
            serverPublicKey: serverPublicKey,
            auth: auth,
            salt: salt
        )
        XCTAssertEqual(pushNotification.accessToken, "c43ecb5528e95f52529ec5fcf03e02966bce3602ff0017bea98a83136df70485")
        XCTAssertEqual(pushNotification.body, "Test")
        XCTAssertEqual(pushNotification.title, "Pipilo Test Account liked your comment on \"Test\"")
        XCTAssertEqual(pushNotification.icon, "")
        XCTAssertEqual(pushNotification.notificationId, 522903)
        XCTAssertEqual(pushNotification.notificationType, .favourite)
        XCTAssertEqual(pushNotification.preferredLocale, "en-gb")
    }

    private func decode(_ base64UrlEncoded: String) throws -> Data {
        return try XCTUnwrap(Data(urlSafeBase64Encoded: base64UrlEncoded))
    }
}
