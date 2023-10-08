//
//  ContentView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//


import Foundation
import SwiftUI
import Alamofire

struct ContentView: View {
    @ObservedObject var you: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    @State var selectedUser = false
    @State var selectedYCategories = false
    @State var selectedJCategories = false
    @State var showDetails = true
    @State var transition = false
    
    init() {
        you.alamofireNetworking(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
        })
        
        jong.alamofireNetworking(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
        })
    }
    
    var body: some View {
        VStack {
            Button(action: { if selectedUser == false {
                selectedUser = true
                showDetails = false
                
                transition = true
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    transition = false
                }
            } else {
                selectedUser = false
                showDetails = true
                
                transition = true
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    transition = false
                }
            }}, label: {
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
            .disabled(transition)
            
            if showDetails {
                Picker("", selection: $selectedYCategories) {
                    ForEach(you.lcategories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
            } else {
                Picker("", selection: $selectedJCategories) {
                    ForEach(jong.lcategories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
            }
            
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
