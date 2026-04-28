import SwiftUI

struct MoneyTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(.decimalPad)
            .textInputAutocapitalization(.never)
    }
}

