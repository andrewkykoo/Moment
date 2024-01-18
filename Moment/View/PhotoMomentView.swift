//
//  PhotoMomentView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI

struct PhotoMomentView: View {
    @ObservedObject var viewModel: MomentsViewModel
    
    var body: some View {
        MomentDetailView(viewModel: viewModel, momentType: .photo)
    }
}

#Preview {
    PhotoMomentView(viewModel: MomentsViewModel())
}
