//
//  LipsumView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/1/25.
//

import SwiftUI

struct LipsumView: View {
    var body: some View {
        VStack ( alignment: .leading, spacing: 12 ) {
            Text( "Lorem Ipsum" ).font( .largeTitle )
            Text( "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque dignissim est iaculis turpis suscipit vulputate. Suspendisse auctor libero id ex cursus interdum quis sed nunc. Vivamus mollis purus eu purus scelerisque, et lacinia est fringilla. Maecenas interdum turpis non urna porttitor gravida. Morbi est massa, rutrum eu ullamcorper vel, molestie quis ante. Phasellus et nulla lectus. Maecenas vehicula purus orci. Sed sed tortor eu eros fermentum pulvinar in eget dui. Duis imperdiet quam ac massa rhoncus placerat." )
            Text( "Ut accumsan lacus arcu. Fusce blandit arcu et arcu lobortis, sed imperdiet dui cursus. Donec ut faucibus tortor, ac dignissim urna. Donec eu feugiat leo. Integer facilisis, lorem sed tempus interdum, felis massa vestibulum felis, ac euismod arcu metus sit amet orci. Aliquam erat volutpat. Duis imperdiet eleifend felis, ut lobortis mauris bibendum a. Phasellus orci elit, pulvinar ac lacus ut, interdum tincidunt est." )
            Text( "Lorem Ipsum" ).font( .largeTitle )
            Text( "Curabitur nec risus dui. Suspendisse potenti. Etiam ut ligula eu sem aliquet rhoncus at at lectus. Praesent a quam eu lorem scelerisque viverra. Sed vehicula elit consectetur libero sollicitudin, nec vehicula neque bibendum. Donec varius hendrerit urna, vel mollis odio interdum non. Ut efficitur tellus molestie, accumsan lorem et, tristique dolor. Cras at ex risus. Vestibulum et erat iaculis, convallis dui in, fermentum urna. Vestibulum semper pretium justo sed dapibus. Quisque eget libero ut lacus malesuada pellentesque. Aliquam dolor turpis, dignissim at velit a, ullamcorper porta lorem. Curabitur tincidunt mauris eget felis pretium tincidunt. Praesent dictum ligula in justo malesuada condimentum." )
            Text( "Maecenas sed urna consequat, iaculis neque eget, tempus quam. Nulla interdum maximus luctus. Quisque lobortis condimentum vestibulum. Aenean tristique volutpat odio et bibendum. Nulla vehicula felis quis justo malesuada tincidunt. Nulla laoreet dictum orci ac tincidunt. Maecenas facilisis magna in consequat porta. Mauris vitae dignissim diam, vestibulum semper orci. Nam vel condimentum enim. Suspendisse eget neque in ante molestie elementum." )
            Text( "Lorem Ipsum" ).font( .largeTitle )
            Text( "Suspendisse dignissim nisl felis, quis tincidunt dolor molestie ut. Vestibulum eget quam a erat porta suscipit. Curabitur elit felis, rutrum vitae fringilla a, fringilla ut tortor. Aenean efficitur accumsan turpis. Aliquam mollis neque felis, nec feugiat mauris blandit mattis. Morbi est sapien, bibendum malesuada placerat vel, iaculis quis nisl. Nullam lobortis accumsan sem, in pellentesque metus egestas sed." )
        }
        .lineSpacing( 4 )
        .privacySensitive( true )
        .redacted( reason: .privacy )
    }
}

#Preview {
    LipsumView()
}
