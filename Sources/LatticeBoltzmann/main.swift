import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct NiallOBroin: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case Blog
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://LatticeBoltzmann.com")!
    var title = "LatticeBoltzmann.github.io"
    var name = "Lattice Boltzmann"
    var description = "Some Photos and Words from Niall Ó Broin"
    var language: Language { .english }
    var imagePath: Path? { nil }
//    var socialMediaLinks: [SocialMediaLink] { [.location, .email, .linkedIn, .github, .twitter] }
}

// This will generate your website using the built-in Foundation theme:
try NiallOBroin().publish(withTheme: .foundation,
                          deployedUsing: .gitHub("TurbulentDynamics/LatticeBoltzmann.github.io.publish"))




