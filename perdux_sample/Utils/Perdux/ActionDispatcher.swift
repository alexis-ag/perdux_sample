import Combine
import Foundation

public protocol ActionDispatcherSubscriber {
    func notify(_ action: ReduxAction)
}

class ActionDispatcher {
    private static var subscribers: [ActionDispatcherSubscriber] = []

    class func subscribe(_ subscriber: ActionDispatcherSubscriber) {
        subscribers.append(subscriber)
    }

    class func emitSync<Action: ReduxAction>(_ action: Action) {
        Logger.log(action)
        Action.executionQueue.sync {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    class func emitAsync<Action: ReduxAction>(_ action: Action) {
        Logger.log(action)
        Action.executionQueue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    class func emitAsync<Action: ReduxAction>(_ action: Action, queue: DispatchQueue) {
        Logger.log(action)
        queue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    class func emitAsyncMain<Action: ReduxAction>(_ action: Action) {
        Logger.log(action)
        DispatchQueue.main.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    class func emitAsync<Action: ReduxAction>(_ action: Action, delay: Double) {
        Logger.log(action)
        Action.executionQueue.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    class func emitAsync<Action: ReduxAction>(_ actions: [Action]) {
        Action.executionQueue.async {
            subscribers.forEach { subscriber in
                actions.forEach { action in
                    Logger.log(action)
                    subscriber.notify(action)
                }
            }
        }
    }

    class func emitSync<E: Effect>(_ effect: E) {
        Logger.log(effect)
        E.executionQueue.sync {
            effect.apply()
        }
    }

    class func emitAsync<E: Effect>(_ effect: E) {
        Logger.log(effect)
        E.executionQueue.async {
            effect.apply()
        }
    }

    class func emitAsync<E: Effect>(_ effects: [E]) {
        E.executionQueue.async {
            effects
                    .forEach { effect in
                        Logger.log(effect)
                        effect.apply()
                    }
        }
    }

    class func emitAsync<E: Effect>(_ effect: E, delay: Double) {
        Logger.log(effect)
        E.executionQueue.asyncAfter(deadline: .now() + delay) {
            effect.apply()
        }
    }
}