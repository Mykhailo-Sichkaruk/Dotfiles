const domainName = url => {
    try {
        const {hostname} = new URL(url)
        if (hostname.endsWith("localhost") || hostname.match(/^(\d|\.)+$/)) {
            return hostname
        }
        return hostname.replace(/(?:[a-zA-Z0-9]+\.)+(\w+\.\w+)/, "$1")
    } catch {
        return null
    }
}
