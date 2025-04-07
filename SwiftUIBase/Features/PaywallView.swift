//
//  PaywallView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/7/25.
//

import SwiftUI
import StoreKit

// https://www.youtube.com/watch?v=fnzU6A4jG0U&ab_channel=VincentPradeilles
// Setup StoreKit configuration file for the items ( Project > Store Kit config file )

struct PaywallView: View {
    let productIds = [ "com.myapp.pro.monthly", "com.myapp.pro.yearly" ]
    
    var body: some View {
        SubscriptionStoreView( productIDs: productIds ) {
            VStack( spacing: 16 ) {
                Image( systemName: "dollarsign.square.fill" )
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle( .green )
                    .frame( height: 80 )
                
                Text( "Subscribe to Pro!" )
            }
            .font( .title )
            .bold()
        }
        .storeButton( .visible, for: .restorePurchases )
        .onInAppPurchaseStart { product in }
        .onInAppPurchaseCompletion { product, result in }
    }
}

#Preview {
    PaywallView()
}
