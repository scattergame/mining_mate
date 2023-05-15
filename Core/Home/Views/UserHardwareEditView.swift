//
//  UserHardwareEditView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct UserHardwareEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var preselectedEditWatchListHardwareIndex = 0
    @State private var selectedHardware: Hardware? = nil
    @State private var selectedCoin: SupportCoinDetail? = nil
    @State private var showCheckmark: Bool = false
    @State private var selectionText_EditWatchListHardware = ["All", "GPU", "ASIC"]
    
    @State private var quantityText: String = ""
    
    let columns = [
        GridItem(.flexible(minimum: 50,maximum: 100))
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
                
                VStack (spacing: 0) {
                    headItemView
                    SwithBarView(preselectedIndex: $preselectedEditWatchListHardwareIndex, selectionText: $selectionText_EditWatchListHardware)
                    
                    allHardwareList
                    
                    Spacer()
                    Divider()
                        .padding()
                    
                    if let _ = selectedHardware {
                        hardwareAddingView
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct UserHardwareEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserHardwareEditView()
            .environmentObject(dev.homeVM)
            .preferredColorScheme(.dark)
    }
}

extension UserHardwareEditView {
    
    private var headItemView: some View {
        
        HStack{
            CircleButtonView(iconName: "xmark")
                .onTapGesture {
                    vm.searchHardwareText = ""
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            SearchBarView(searchText: $vm.searchHardwareText)
            Spacer()
            HStack {
                CircleButtonView(iconName: "envelope.open")
                    .onTapGesture {
                    }
                    .overlay {
                        CircleButtonView(iconName: "checkmark")
                            .opacity(showCheckmark ? 1.0 : 0.0)
                    }
            }
        }
    }
    
    private var allHardwareList: some View {
        
        ZStack{
            if (preselectedEditWatchListHardwareIndex==0) {
                List {
                    ForEach(vm.allHardwares) { hardware in
                        HardwareRowView(hardware: hardware)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                updateSelectedHardware(hardware: hardware)
                            }
                    }
                }
                .listStyle(PlainListStyle())
                
            } else if (preselectedEditWatchListHardwareIndex==1) {
                List {
                    ForEach(vm.allGPUs) { hardware in
                        HardwareRowView(hardware: hardware)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                updateSelectedHardware(hardware: hardware)
                            }
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                List {
                    ForEach(vm.allASICs) { hardware in
                        HardwareRowView(hardware: hardware)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                updateSelectedHardware(hardware: hardware)
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private var hardwareAddingView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text( selectedHardware?.name ?? "unknown")
            Divider()
            HStack {
                Text("Quantity: ")
                Spacer()
                TextField(selectedHardware == nil ? "0" : "Ex: 2",
                          text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            Divider()
            HStack {
                Text("Select Coin: \(selectedCoin?.symbol ?? "")")
                Spacer()
                ScrollView(.horizontal) {
                    HStack (spacing: 15) {
                        ForEach (selectedHardware?.support_coins_details ?? [], id: \.name) { item in
                            //Text(item.name ?? "unknown")
                            HardwareCoinProfitVerticalView(coin: item)
                                .onTapGesture {
                                    updateSelectedCoin(coin: item)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( selectedCoin?.name == item.name ?
                                                 Color.theme.accent :
                                                 Color.clear, lineWidth: 1)
                                )
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width/1.8)
            }
            HStack {
                Button {
                    // Add Hardware to List
                    saveHardwaretoList()
                } label: {
                    Image (systemName: "pencil.circle.fill")
                        .font(.headline)
                        .foregroundColor(checkSavingNeeded() ? Color.theme.accent : Color.theme.secondaryText)
                    Text("Add to list")
                        .foregroundColor(checkSavingNeeded() ? Color.theme.accent :
                            Color.theme.secondaryText)
                }
                .disabled(checkSavingNeeded() ? false : true)
                
                Spacer()
                
                Button {
                    // Remove Coin From List
                    removeHardwarefromList()
                } label: {
                    Image (systemName: "trash")
                        .font(.headline)
                        .foregroundColor(checkDeleteNeeded() ? Color.theme.red : Color.theme.secondaryText)
                    Text("Remove from list")
                        .foregroundColor(checkDeleteNeeded() ? Color.theme.red : Color.theme.secondaryText)
                }
            }
            
            Spacer()
            
            
        }
    }
    
    private func updateSelectedHardware_inlist(hardware: Hardware) {
        if selectedHardware?.name == hardware.name {
            unSelectHardware()
            unSelectCoin()
        } else {
            selectedHardware = hardware
            selectedCoin = hardware.myCoin
            quantityText = String(hardware.myQuantity ?? 0)
        }
    }
    
    private func updateSelectedHardware(hardware: Hardware) {
        if selectedHardware?.name == hardware.name {
            unSelectHardware()
            unSelectCoin()
        } else {
            selectedHardware = hardware
            unSelectCoin()
            quantityText = ""
        }
    }
    
    private func updateSelectedCoin(coin: SupportCoinDetail) {
        if selectedCoin?.name == coin.name {
            unSelectCoin()
        } else {
            selectedCoin = coin
        }
    }
    
    private func unSelectCoin() {
        selectedCoin = nil
    }
    
    private func unSelectHardware() {
        selectedHardware = nil
        vm.searchHardwareText = ""
        quantityText = ""
    }
    
    private func checkSavingNeeded() -> Bool {
        if (quantityText=="") { return false }
        if (selectedHardware == nil) { return false }
        if (selectedCoin == nil) { return false }
        if ( Int(quantityText) ?? 0 == 0 ) {return false}
        if (selectedHardware?.myQuantity ?? 0 == Int(quantityText) ?? 0) {return false}
        return true
    }
    
    private func checkDeleteNeeded() -> Bool {
        if (selectedHardware == nil) { return false }
        if (selectedHardware?.myQuantity ?? 0 == 0) {return false}
        return true
    }
    
    private func saveHardwaretoList() {
        
        guard
            let hardware = selectedHardware,
            let amount = Int(quantityText),
            let coin = selectedCoin
        else {return}
        
        //save to watchlist
        
        vm.updateUserHardwareList(hardware: hardware, amount: amount, coin: coin)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            unSelectHardware()
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
    
    private func removeHardwarefromList() {
        guard
            let hardware = selectedHardware
        else {return}
        
        vm.deleteHardwareList(hardware: hardware)
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
