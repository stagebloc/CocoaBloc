//
//  Curry.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

// This file makes me so sad

// swiftlint:disable variable_name
// swiftlint:disable line_length
internal func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z>(function: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y) -> Z) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z {
	return { (`a`: A) -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`b`: B) -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`c`: C) -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`d`: D) -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`e`: E) -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`f`: F) -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`g`: G) -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`h`: H) -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`i`: I) -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`j`: J) -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`k`: K) -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`l`: L) -> M -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`m`: M) -> N -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`n`: N) -> O -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`o`: O) -> P -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`p`: P) -> Q -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`q`: Q) -> R -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`r`: R) -> S -> T -> U -> V -> W -> X -> Y -> Z in { (`s`: S) -> T -> U -> V -> W -> X -> Y -> Z in { (`t`: T) -> U -> V -> W -> X -> Y -> Z in { (`u`: U) -> V -> W -> X -> Y -> Z in { (`v`: V) -> W -> X -> Y -> Z in { (`w`: W) -> X -> Y -> Z in { (`x`: X) -> Y -> Z in { (`y`: Y) -> Z in function(`a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`) } } } } } } } } } } } } } } } } } } } } } } } } }
}
// swiftlint:enable variable_name
// swiftlint:enable line_length
