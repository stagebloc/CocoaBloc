//
//  SignalProducer+CocoaBloc.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/30/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import ReactiveCocoa
import Result

extension SignalProducer {
    
    /**
     Tries mapping a signal with a throws closure. If the closure throws when executed,
     the thrown error is used if its type matches the error type of the signal.
     If the error types differ, or the closure returns nil, the fallbackError is used.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    internal func tryOptionalMap<T>(failWith fallbackError: Error, transform: (Value) throws -> T?) -> SignalProducer<T, Error> {
        return attemptMap { (value: Value) -> Result<T, Error> in
            do {
                let result = Result(try transform(value), failWith: fallbackError)
                return result
            }
            catch let error as Error {
                return .Failure(error)
            }
            catch {
                return .Failure(fallbackError)
            }
        }
    }
}
