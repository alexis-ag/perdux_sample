import SwiftUI

struct ConnectivityInfoContainer: View {
    let props: Props

    @EnvironmentObject private var connectivityState: NetworkState

    var body: some View {
        ConnectivityInfoView(props: .init(
                status: connectivityState.networkStatus
        ))
    }
}
