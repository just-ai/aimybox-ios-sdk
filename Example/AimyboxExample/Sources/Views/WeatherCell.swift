import Aimybox
import SDWebImage
import UIKit

final
class WeatherCell: UITableViewCell {

    var weatherReply: WeatherReply? {
        didSet {
            weatherDescriptionLabel.attributedText = weatherReply?.weatherDescription.attributed(
                style: .heading6,
                textColor: .white
            )
            weatherImageView.sd_setImage(with: weatherReply?.weatherImageURL) { [weak self] image, _, _, _ in
                self?.weatherImageView.image = image?.withRenderingMode(.alwaysTemplate) ?? weatherIcon
            }
            temperatureLabel.attributedText = weatherReply?.temperatureString.attributed(
                style: .temperature,
                textColor: .white
            )
            dateLabel.attributedText = weatherReply?.date.attributed(style: .smallText, textColor: .white)
            locationLabel.attributedText = weatherReply?.city.attributed(style: .smallText, textColor: .white)
            setNeedsLayout()
        }
    }

    private
    let gradientView = GradientView().with {
        $0.clipsToBounds = true
        $0.colors = [.init(hex: 0x4BA8F8, alpha: 0.7), .init(hex: 0x4D83E9)]
        $0.endPoint = .init(x: 1, y: 0)
        $0.layer.cornerRadius = 10
        $0.startPoint = .init(x: 0, y: 0)
    }

    private
    let weatherDescriptionLabel = UILabel()

    private
    let weatherImageView = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.heightAnchor.constraint(equalToConstant: 41).activate()
        $0.tintColor = .white
        $0.widthAnchor.constraint(equalToConstant: 52).activate()
    }

    private
    let temperatureLabel = PaddingLabel().with {
        $0.edgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: -5, right: 0)
    }

    private
    let dateLabel = UILabel()

    private
    let locationImageView = UIImageView(image: UIImage(named: "location_icon")).with {
        $0.widthAnchor.constraint(equalToConstant: 7.5).activate()
        $0.heightAnchor.constraint(equalToConstant: 10).activate()
    }

    private
    let locationLabel = UILabel()

    private
    lazy var stackView = makeVerticalStackView().with {
        $0.clipsToBounds = true
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 10
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 25, right: 15)
        $0.spacing = 11

        let location = makeHorizontslStackView(arrangedSubviews: [locationImageView, locationLabel]).with {
            $0.spacing = 6
            $0.distribution = .fill
        }
        let locationAndDate = makeVerticalStackView(arrangedSubviews: [dateLabel, location]).with {
            $0.spacing = 9
        }
        let bottomStack = [weatherImageView, temperatureLabel, locationAndDate]
        let contentStack = makeHorizontslStackView(arrangedSubviews: bottomStack).with {
            $0.spacing = 15
            $0.alignment = .center
        }
        [weatherDescriptionLabel, contentStack].forEach($0.addArrangedSubview)
    }

    override
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(gradientView)
        contentView.addSubview(stackView)

        buildConstraintsAsForCard(parent: contentView, child: gradientView)
        buildConstraintsAsForCard(parent: contentView, child: stackView)
    }

    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private
let weatherIcon = UIImage(named: "weather_icon")
