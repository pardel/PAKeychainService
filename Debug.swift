

func devPrintln<T>(to_print: T) {
#if DEBUG
    dispatch_async(dispatch_get_main_queue()) {
        println("💭 \(to_print)")
    }
#endif
}

