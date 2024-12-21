//
//  PathModel.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//


import Foundation

class PathModel: ObservableObject {
  @Published var tabPaths: [PathType]
  
  init(paths: [PathType] = []) {
    self.tabPaths = paths
  }
}
