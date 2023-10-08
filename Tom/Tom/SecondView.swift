//
//  SecondView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//

import Foundation
import SwiftUI
import Alamofire

struct SecondView: View {
    @ObservedObject var networking: Networking = Networking()
    @State var selectedUser = false
    @State var selectedCategories = false
    
    init() {
        networking.alamofireNetworking(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
        })
    }
    
    var body: some View {
        VStack {
            Button(action: { if selectedUser == false { selectedUser = true } else { selectedUser = false }}, label: {
                    if selectedUser == false {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    } else {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .colorInvert()
                    }
                }
            )
            
            Picker("", selection: $selectedCategories) {
                ForEach(networking.lcategories, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send")
                }.padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
