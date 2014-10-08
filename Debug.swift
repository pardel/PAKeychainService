

func devPrintln<T>(to_print: T) {
#if DEBUG
    println("💭 \(to_print)")
#endif
}

