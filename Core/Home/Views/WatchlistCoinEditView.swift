//
//  WatchlistCoinEditView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import SwiftUI

struct WatchlistCoinEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if (colorScheme == .light) {
                    LightBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                } else {
                    DarkBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                }
                
                VStack (alignment: .leading, spacing: 0) {
                        
                    headItemView
                    currentCoinLogoList
                    Divider()
                        .foregroundColor(Color.theme.accent)
                        .shadow(color: Color.theme.accent, radius: 5, x: 0, y: 0)
                    
                    coinLogoList
                        .padding(.bottom)
                    
                    if let _ = selectedCoin {
                        coinHoldingEdit
                    }
                }
                .onChange(of: vm.searchCoinText) { value in
                    if value == "" {
                        unSelectCoin()
                    }
                }
            .navigationBarHidden(true)
            }
        }
    }
}

struct WatchlistCoinEditView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistCoinEditView()
            .environmentObject(dev.homeVM)
            .preferredColorScheme(.dark)
    }
}


extension WatchlistCoinEditView {
    
    private var headItemView: some View {
        HStack{
            CircleButtonView(iconName: "xmark")
                .onTapGesture {
                presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            SearchBarView(searchText: $vm.searchCoinText)
            Spacer()
            HStack {
                
                CircleButtonView(iconName: checkSavingNeeded() ? "envelope.open" : "envelope.fill")
                    .onTapGesture {
                        if checkSavingNeeded() {
                            saveCointoList()
                        }
                    }
                    .overlay {
                        CircleButtonView(iconName: "checkmark")
                            .opacity(showCheckmark ? 1.0 : 0.0)
                    }
            }
        }
    }
    
    private var currentCoinLogoList: some View {
        
        ScrollView (.horizontal)  {
            HStack {
                ForEach(vm.watchlistCoins) { coin in
                    CoinLogoView(coin: coin)
                        .padding(.horizontal,10)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( selectedCoin?.id == coin.id ?
                                            Color.theme.accent :
                                            Color.clear, lineWidth: 1)
                        )
                }
            }
            .padding()
        }
    }
    
    private var coinLogoList: some View {
        
        ZStack {
            
            if (colorScheme == .light) {
                LightBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            } else {
                DarkBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            }
            
            List {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(vm.restCoins) { coin in
                                CoinLogoView(coin: coin)
                                    //.padding(10)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            updateSelectedCoin(coin: coin)
                                        }
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke( checkCoininList(coin: coin) ?
                                                     Color.theme.secondaryText.opacity(0.5) :
                                                     Color.clear,
                                                     lineWidth: selectedCoin?.id == coin.id ?
                                                     0 : 1)
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke( selectedCoin?.id == coin.id ?
                                                     Color.theme.accent :
                                                     Color.clear, lineWidth: 1)
                                    )
                            }
                    }
            }
        }
    }
    
    private var coinHoldingEdit: some View {
        
        VStack (spacing: 10) {
            HStack {
                Text( "Current Price of \(selectedCoin?.symbol.uppercased() ?? ""): " )
                Spacer()
                Text( selectedCoin?.current_price.asCurrencyWith6Decimals() ?? "")
            }
            .transaction { transaction in
                transaction.animation = .none
            }
            Divider()
            HStack {
                Text("Amount: ")
                Spacer()
                TextField(selectedCoin == nil ? "" : "Ex: 2.0",
                          text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
            
            HStack {
                
                Button {
                    // Add Coin to List
                    //print ("Now Save")
                    saveCointoList()
                } label: {
                    Image (systemName: "cart.fill.badge.plus")
                        .font(.headline)
                        .foregroundColor(checkSavingNeeded() ? Color.theme.accent : Color.theme.secondaryText)
                    Text("Add to list")
                        .foregroundColor(checkSavingNeeded() ? Color.theme.accent : Color.theme.secondaryText)
                }
                .disabled(checkSavingNeeded() ? false : true)
                
                Spacer()
                
                Button {
                    // Remove Coin From List
                    removeSelectionCoinfromList()
                } label: {
                    Image (systemName: "trash")
                        .font(.headline)
                        .foregroundColor(checkDeleteNeeded() ? Color.theme.red : Color.theme.secondaryText)
                    Text("Remove from list")
                        .foregroundColor(checkDeleteNeeded() ? Color.theme.red : Color.theme.secondaryText)
                }
                .disabled(checkDeleteNeeded() ? false : true)
            }
            .padding()

        }
        .padding()
        .foregroundColor( selectedCoin == nil ? Color.theme.background : Color.theme.accent)
        .transaction { transaction in
            transaction.animation = .none
        }
        
    }
    
    
    private func checkCoininList(coin: CoinModel) -> Bool {
        if let _ = vm.watchlistCoins.first(where: {$0.id == coin.id} ) {
            return true
        }
        return false
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.current_price ?? 0.0)
        }
        return 0
    }
    
    private func checkSavingNeeded() -> Bool {
        if ( (selectedCoin != nil) &&
             ( selectedCoin?.currentHolding != Double(quantityText) ) ) {
            return true
        }
        return false
    }
    
    private func checkDeleteNeeded() -> Bool {
        guard let coin = selectedCoin else {return false}
        if let _ = vm.watchlistCoins.first(where: {$0.id == coin.id }) {
            return true
        }
        return false
    }
    
    private func saveCointoList() {
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else {return}
        
        //print ("Inside of save Coin to List")
        //print (coin.name)
        
        //save to watchlist
        //print (selectedCoin?.id ?? 0)
        vm.updateWatchlist(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            unSelectCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func unSelectCoin() {
        selectedCoin = nil
        vm.searchCoinText = ""
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        if selectedCoin?.id == coin.id {
            selectedCoin = nil
        } else {
            selectedCoin = coin
            if let watchlistCoin = vm.watchlistCoins.first(where: {$0.id == coin.id }),
               let amount = watchlistCoin.currentHolding {
                quantityText = amount.asNumberString()
            } else {
                quantityText = ""
            }
        }
    }
    
    private func removeSelectionCoinfromList() {
        
        guard let coin = selectedCoin else {return}
        
        //remove from watchlist
        vm.deleteWatchlistCoin(coin: coin)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            unSelectCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
}
