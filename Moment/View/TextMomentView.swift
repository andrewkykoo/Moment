//
//  TextMomentView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI

struct TextMomentView: View {
    @ObservedObject var viewModel: MomentsViewModel
    
    var body: some View {
        SaveMomentView(viewModel: viewModel, momentType: .text)
    }
}

#Preview {
    TextMomentView(viewModel: MomentsViewModel())
}
