// Initialize the main wrapper &
// set up callbacks
if (typeof arturo === 'undefined') {
    arturo = {
        // call backend method 
        // with given arguments
        call: (method, ...args)=>{
            return window.callback("call", JSON.stringify({
                "method": method,
                "args": args
            }))
        },

        // invoke a specific method
        invoke: (object, method, ...args)=>{
            return window.callback("invoke", JSON.stringify({
                "object": object,
                "method": method,
                "args": args
            }))
        },

        // execute arbitrary arturo code 
        // in backend
        exec: (code)=>{
            return window.callback("exec", JSON.stringify(code))
        }
    }
}

// setup events
window.onload = ()=>{
    return window.callback("event", JSON.stringify("load"))
}
window.onerror = ()=>{
    return window.callback("event", JSON.stringify("error"))
}