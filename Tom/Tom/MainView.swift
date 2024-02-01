//
//  ContentView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//


import Foundation
import SwiftUI
import Alamofire

struct MainView: View {
    @ObservedObject var you: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    
    @State var selectedUser = false
    @State var selectedYCategories: Int = 0
    @State var selectedJCategories: Int = 0
    @State var showDetails = true
    @State var transition = false
    @State var alertShowing = false
    
    init() {
        you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
            
            
        })
        
        jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
            
            
        })
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if selectedUser == false {
                            you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
                                
                                
                            })
                        } else {
                            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                                
                                
                            })
                        }
                    }, label: {
                        if selectedUser == false {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                        } else {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                                .colorInvert()
                        }
                            
                    })
                }.padding(15.0)
                
                Spacer()
            }
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
                        ForEach(you.lcategories.indices, id: \.self) { index in Text(you.lcategories[index]) }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: selectedYCategories, perform: { newValue in print("Selected Unit: \(you.lcategories[newValue])", "Selected Index: \(newValue)")})
                } else {
                    Picker("", selection: $selectedJCategories) {
                        ForEach(jong.lcategories.indices, id: \.self) { index in Text(jong.lcategories[index]) }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: selectedJCategories, perform: { newValue in print("Selected Unit: \(jong.lcategories[newValue])", "Selected Index: \(newValue)")})
                }
                
                Button(action: {
                    alertShowing = false
                    
                    if selectedUser == false {
                        you.triggerGIT(url: "http://221.159.102.58:8000/api/trigger/upload/git", bodyl: ["user": "You", "category": you.lcategories[selectedYCategories]], completion: { (results) in
                            
                            alertShowing = true
                            
                        })
                    } else {
                        jong.triggerGIT(url: "http://221.159.102.58:8000/api/trigger/upload/git", bodyl: ["user": "Jong", "category": jong.lcategories[selectedJCategories]], completion: { (results) in
                            
                            alertShowing = true
                            
                        })
                    }
                    
                })
                {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send")
                    }.padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                }
                .alert("Success", isPresented: $alertShowing) {
                    Button("OK", role: .cancel) {  }
                        .padding()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
