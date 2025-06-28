package egg

import std.collection.HashMap

class Env {
    let map = HashMap<String, Object>()
    var out: Option<Env>

    public init(out: Env) {
        this.out = out
    }

    public init() {
        this.out = Option<Env>.None
    }

    public func get(name: String): Option<Object> {
        if (map.contains(name)) {
            return Option<Object>.Some(map[name])
        }
        return out?.get(name) ?? Option<Object>.None
    }

    public func define(name: String, value: Object): Unit {
        if (map.contains(name)) {
            map[name] = value
        } else {
            map.put(name, value)
        }
    }

    public func set(name: String, value: Object): Unit {
        if (map.contains(name)) {
            map[name] = value
            return
        }
        if (out.isSome()) {
            out?.set(name, value)
            return
        }
        throw Exception("变量未定义: ${name}")
    }
}
