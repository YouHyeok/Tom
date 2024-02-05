//
//  ScheduleView.swift
//  Tom
//
//  Created by 김종혁 on 2/1/24.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var you: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    
    @State var selectedUser = false
    @State var selectedYCategories: Int = 0
    @State var selectedYBCategories: Int = 0
    @State var selectedJCategories: Int = 0
    @State var selectedJBCategories: Int = 0
    @State var selectedYTimes: Int = 0
    @State var selectedJTimes: Int = 0
    @State var showDetails = true
    @State var transition = false
    @State var alertShowing = false
    @State var ybcategories: [String] = []
    @State var jbcategories: [String] = []
    @State var is_yb_loading = true
    @State var is_jb_loading = true
    
    init() {
        you.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "You"], completion: { (categories) in
            
        })
        
        you.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "You"], completion: { (scheduled_tasks) in
            
        })
        
        jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
            
        })
        
        jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
            
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
                            
                            you.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "You"], completion: { (scheduled_tasks) in
                                
                            })
                        } else {
                            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                                
                            })
                            
                            jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
                                
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
                    VStack(spacing: -65) {
                        Picker("", selection: $selectedYBCategories) {
                            ForEach(ybcategories.indices, id: \.self) { index in
                                Text(ybcategories[index]) }
                        }
                        .pickerStyle(.wheel)
                        
                        HStack {
                            Picker("", selection: $selectedYCategories) {
                                ForEach(you.lcategories.indices, id: \.self) { index in
                                    
                                    if !is_yb_loading {
                                        if you.lcategories[index].contains(ybcategories[selectedYBCategories]) {
                                            Text(you.lcategories[index])
                                        }
                                    }
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: selectedYCategories, perform: { newValue in print("Selected Unit: \(you.lcategories[newValue])", "Selected Index: \(newValue)")
                                
                                if let scheduledTask = you.lscheduledTasks.last(where: {$0.task == you.lcategories[newValue]}) {
                                    you.selectedLtimesid = Int(scheduledTask.scheduled_time!)
                                } else {
                                    you.selectedLtimesid = 0
                                }
                            })
                            .padding([.leading, .trailing], 5)
                            
                            Picker("", selection: $you.selectedLtimesid) {
                                ForEach(you.ltimes.indices, id: \.self) { index in Text(you.ltimes[index]) }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: you.selectedLtimesid, perform: { newValue in
                                print(newValue)
                            })
                            .padding([.leading, .trailing], 5)
                        }
                    }
                    .frame(height: 375)
                    .padding(.bottom, 5)
                    
                } else {
                    VStack(spacing: -65) {
                        Picker("", selection: $selectedJBCategories) {
                            ForEach(jbcategories.indices, id: \.self) { index in
                                Text(jbcategories[index]) }
                        }
                        .pickerStyle(.wheel)
                        
                        HStack {
                            Picker("", selection: $selectedJCategories) {
                                ForEach(jong.lcategories.indices, id: \.self) { index in
                                    if !is_jb_loading {
                                        if jong.lcategories[index].contains(jbcategories[selectedJBCategories]) {
                                            Text(jong.lcategories[index])
                                        }
                                    }
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: selectedJCategories, perform: { newValue in print("Selected Unit: \(jong.lcategories[newValue])", "Selected Index: \(newValue)")
                                
                                if let scheduledTask = jong.lscheduledTasks.last(where: {$0.task == jong.lcategories[newValue]}) {
                                    jong.selectedLtimesid = Int(scheduledTask.scheduled_time!)
                                } else {
                                    jong.selectedLtimesid = 0
                                }
                            })
                            .padding(5)
                            
                            Picker("", selection: $jong.selectedLtimesid) {
                                ForEach(jong.ltimes.indices, id: \.self) { index in Text(jong.ltimes[index]) }
                            }
                            .onChange(of: jong.selectedLtimesid, perform: { newValue in
                                print(newValue)
                            })
                            .pickerStyle(.wheel)
                            .padding(5)
                        }
                    }
                    .frame(height: 375)
                    .padding(.bottom, 5)
                }
                    
                Button(action: {
                    alertShowing = false
                    
                    if selectedUser == false {
                        let registerScheduleRequest = RegisterScheduleRequest(user: "You", task: you.lcategories[selectedYCategories], scheduled_time: you.selectedLtimesid)
                        
                        you.registerSchedule(url: "http://221.159.102.58:8000/api/register/schedule", bodyl: registerScheduleRequest.toDictionary, completion: { (results) in
                            
                            alertShowing = true
                        })
                    } else {
                        let registerScheduleRequest = RegisterScheduleRequest(user: "Jong", task: jong.lcategories[selectedJCategories], scheduled_time: jong.selectedLtimesid)
                        
                        jong.registerSchedule(url: "http://221.159.102.58:8000/api/register/schedule", bodyl: registerScheduleRequest.toDictionary, completion: { (results) in
                            
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
        .onAppear {
            DispatchQueue.main.async {
                self.ybcategories = Array(Set(you.lcategories.map { value in
                    
                    value.components(separatedBy: "-").first!
                })).sorted()
                
                self.is_yb_loading = false
                
                self.jbcategories = Array(Set(jong.lcategories.map { value in
                    
                    value.components(separatedBy: "-").first!
                })).sorted()
                
                self.is_jb_loading = false
            }
        }
        .task {
            if let scheduledTask = you.lscheduledTasks.last(where: {$0.task == you.lcategories[0]}) {
                you.selectedLtimesid = Int(scheduledTask.scheduled_time!)
            } else {
                you.selectedLtimesid = 0
            }
            
            if let scheduledTask = jong.lscheduledTasks.last(where: {$0.task == jong.lcategories[0]}) {
                jong.selectedLtimesid = Int(scheduledTask.scheduled_time!)
            } else {
                jong.selectedLtimesid = 0
            }
        }
    }
        
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let mockYou = Networking()
        let mockJong = Networking()

        mockYou.lcategories = ["You-Category1", "You-Category2", "Test-Category1", "Test-Category2"]
        mockYou.lscheduledTasks = [
            ScheduledTasks(user: "You", task: "Category1", scheduled_id: "1", scheduled_time: 10),
            ScheduledTasks(user: "You", task: "Category2", scheduled_id: "2", scheduled_time: 11)
        ]
        mockYou.ltimes = ["10:00", "11:00"]

        mockJong.lcategories = ["Jong-Category3", "Jong-Category4", "Test-Category3", "Test-Category4"]
        mockJong.lscheduledTasks = [
            ScheduledTasks(user: "Jong", task: "Category3", scheduled_id: "3", scheduled_time: 14),
            ScheduledTasks(user: "Jong", task: "Category4", scheduled_id: "4", scheduled_time: 15)
        ]
        mockJong.ltimes = ["14:00", "15:00"]
        
        var scheduleView = ScheduleView()
        
        scheduleView.you = mockYou
        scheduleView.jong = mockJong

        return scheduleView
    }
}
