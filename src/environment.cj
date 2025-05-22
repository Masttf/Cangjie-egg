package egg
import std.collection.HashMap
class Env {
    let map = HashMap<String, Object>()
    var out : Env
    public init(out: Env) {
        this.out = out
    }
    public func get(name: String): Option<Object> {
        if(map.contains(name)) {
            return Option<Object>.Some(map[name])
        } else {
            return Option<Object>.None
        }
    }
    public func set(name: String, value: Object) : Unit {
        map[name] = value
    }
}
