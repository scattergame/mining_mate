//
//  SearchBarView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/8/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(
                            searchText.isEmpty ?
                            Color.theme.secondaryText:
                            Color.theme.accent)
                    TextField("Search here", text: $searchText)
                        .disableAutocorrection(true)
                        .foregroundColor(Color.theme.accent)
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
                        .overlay(
                            Image(systemName: "xmark.circle.fill")
                                .padding()
                                .offset(x: 10)
                                .foregroundColor(Color.theme.accent)
                                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                    searchText = ""
                                }
                            ,alignment: .trailing
                        )
                }
                .font(.headline)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                    .fill(Color.theme.background)
                    .shadow(color: Color.theme.accent.opacity(0.2), radius: 20, x: 0, y: 0)
                )
            }
            .padding(.horizontal)
        }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            //.preferredColorScheme(.dark)
    }
}
