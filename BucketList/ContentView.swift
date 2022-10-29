//
//  ContentView.swift
//  BucketList
//
//  Created by Jacob and Shalise on 4/28/22.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        
        if viewModel.isUnlocked {
        
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "heart.circle")
                            .resizable()
                            .foregroundColor(Color.myCustomColor)
                            .frame(width: 33, height: 33)
                            .background(.clear)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                        viewModel.selectedPlace = location
                    }
                }
            }
                .ignoresSafeArea()
            ZStack{
                Circle()
                    .fill(Color.myCustomColor)
                    .opacity(0.35)
                    .frame(width: 32, height: 32)
                Circle()
                    .fill(.white)
                    .frame(width: 5, height: 5)
            }
           
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.addLocation()
                        
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.black.opacity(0.4))
                            .foregroundColor(Color.myCustomColor2)
                            .font(.title)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .strokeBorder(Color.myCustomColor, lineWidth: 2)
                            )
                            .padding(.trailing)
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
        } else {
            
            ZStack{
                Image("Globe")
                    .resizable()
                    .ignoresSafeArea()
                
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding(40)
                .background(Color.black.opacity(0.4))
                .font(.title3)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.brown, lineWidth: 2)
                )
                .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.authenticationError)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
