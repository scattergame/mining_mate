//
//  UserSettingView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/9/22.
//

import SwiftUI
import SwiftUIX
import MessageUI


struct UserSettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State var isShowingMailView = false
    @State var alertNoMail = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @State private var isSavePressed: Bool = false

    
    // MARK: Apple Storage
    @AppStorage("electricityRate") var electricityRateAS: Double = 0.1
    @AppStorage("refreshRateInt") var refreshRate: Int = 2
    @AppStorage("refreshRate") var refreshRateAS: AutoRefreshOption = AutoRefreshOption.two
    
    @State var electricityRateText: String = ""
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
                
                ScrollView {
                    
                    VStack {
                        userSettingViewHeader
                        userSettingTextField
                        saveButten
                        Spacer()
                        
                        Divider()
                            .padding()
                    }
                    .toolbar{
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                UIApplication.shared.endEditing()
                            } label: {
                                Text("Done")
                            }
                        }
                    }
                    
                    NavigationLink(destination: ThridPartyView() ) {
                        thirdPartyButton
                    }
                    
                    contactAuthorButton
                                        
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
            .environmentObject(dev.homeVM)
    }
}

extension UserSettingView {
    
    private var userSettingViewHeader: some View {
        HStack{
            CircleButtonView(iconName: "xmark")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
        }
    }
    
    private var userSettingTextField: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            
            Text("Input Electricity Rate:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            Text("Usually electricity cost varies from a few cents to one buck...")
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal)
            
            HStack {
                Text("Electricity Rate:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(height: 50)
                Spacer()
                TextField("\(electricityRateAS.asCurrencyWith2Decimals())", text: $electricityRateText)
                    .font(.headline)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(height: 50)
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .padding()
                Spacer()
                Text("$ / kWh")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(height: 50)
            }
            .padding(.horizontal)
            .foregroundColor(Color.theme.accent)
            
            Divider()
                .padding()
            
            Text("Select Autorefresh Rate:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            Text("Caution:")
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal)
            Text ("All APIs used in this App are free, and have refresh limits. Users could be blocked for a couple of minutes if refresh data too often.")
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal)
            
            HStack {
                Text("AutoRefresh Rate:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(height: 50)
                Spacer()
                
                Menu {
                    Picker("", selection: $refreshRateAS) {
                        ForEach (AutoRefreshOption.allCases, id: \.rawValue) { item in
                            Text(item.rawValue)
                                .tag(item)
                        }
                    }
                } label: {
                    Text(refreshRateAS.rawValue)
                        .font(.headline)
                }
            }
            .padding()
        }
        
    }
    
    private var saveButten: some View {
        
        Text("Save")
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                    .cornerRadius(10)
            )
            .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding()
            .onTapGesture {
                //
                saveUserSetting()
                UIApplication.shared.endEditing()
            }
            .scaleEffect(isSavePressed ? 1.05 : 1.0)
            .pressEvents {
                withAnimation(.easeIn(duration: 0.2)) {
                    isSavePressed = true
                }
            } onRelease: {
                withAnimation(.easeIn(duration: 0.2)) {
                    isSavePressed = false
                }
            }

    }
    
    private var contactAuthorButton: some View {
        
        HStack {
            Link(destination: URL(string: "mailto:maroonaggie2008@gmail.com")!) {
                CircleButtonView(iconName: "paperplane")
                Spacer()
                Text("Send me email \(Image(systemName: "envelope"))")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                CircleButtonView(iconName: "arrow.right")
            }
        }
        .frame(height: 50)
        .background(
            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                .cornerRadius(10)
        )
        .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding()
    }
    
    private var thirdPartyButton: some View {
        
        HStack {
            CircleButtonView(iconName: "info")
            Text("Third party information")
                .font(.headline)
                .fontWeight(.semibold)
            Spacer()
            CircleButtonView(iconName: "arrow.right")
        }
        .frame(height: 50)
        .background(
            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                .cornerRadius(10)
        )
        .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding()
        
    }
    
    func saveUserSetting() {
        //print ("Your previous rate is \(electricityRateAS.asCurrencyWith2Decimals())")
        //print ("Your previous refresh rate is \(refreshRateAS) minutes")
        
        if ( electricityRateText.count > 0) {
            electricityRateAS = Double(electricityRateText) ?? electricityRateAS
        }
        
        var refreshminute: Int {
            switch refreshRateAS {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            case .five:
                return 5
            case .ten:
                return 10
            case .fifteen:
                return 15
            case .thirty:
                return 30
            case .sixty:
                return 60
            }
        }
        refreshRate = refreshminute
        vm.reloadAllData()
        //print ("Saved! Your current rate is \(electricityRateAS.asCurrencyWith2Decimals())")
        //print ("Your current refresh rate is \(refreshRateAS) minutes")
    }
    
}
