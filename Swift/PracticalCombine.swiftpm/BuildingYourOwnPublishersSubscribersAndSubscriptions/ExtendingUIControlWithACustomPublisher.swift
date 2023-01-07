//
//  File.swift
//  
//
//  Created by s_yamada on 2023/01/02.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class CombineSystemInspectViewController: UIViewController {
    let label = UILabel()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.heightAnchor.constraint(equalToConstant: 50),
            slider.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        slider
            .publisher(for: .valueChanged)
//            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { control in
                guard let slider = control as? UISlider else { return }
                print(slider.value)
            }.store(in: &cancellables)
    }
}

// MARK: - Publisher
extension UIControl {
    struct EventPublisher: Publisher {
        typealias Output  = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
            let subscription = EventSubscription(control: control, event: event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

struct CombineSystemInspectRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CombineSystemInspectViewController {
        CombineSystemInspectViewController()
    }
    
    func updateUIViewController(_ uiViewController: CombineSystemInspectViewController, context: Context) {
    }
}


// MARK: - Subscription
extension UIControl {
    class EventSubscription<S: Subscriber>: Subscription where S.Input == UIControl, S.Failure == Never {
        
        let control: UIControl
        let event: UIControl.Event
        var subscriber: S?
        var currentDemand = Subscribers.Demand.none
        
        init(control: UIControl, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addAction(UIAction(handler: { [weak self] _ in self?.eventOccured() }), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
            subscriber = nil
            control.removeAction(UIAction(handler: { [weak self] _ in self?.eventOccured() }), for: event)
        }
        
        func eventOccured() {
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(control) ?? .none
                currentDemand -= 1
            }
        }
    }
}

// MARK: - call publisher for UIControl Event
extension UIControl {
    func publisher(for event: Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }
}
