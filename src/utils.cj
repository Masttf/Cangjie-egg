package egg

class Utils {
    public static func convertToObejct<T>(value: T) : Object {
        let res = (value as Object).getOrThrow({=> Exception("类型转换错误")})
        return res
    }
}