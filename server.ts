//@ts-check


import { createServer } from 'http'
const server = createServer((req, res) => {
    req.on('data', data => {
        console.log('got data', data)
    })
    res.write("hi from js")
    res.end()
    console.log("got a connection")
})


server.listen(3000)

console.log('server is listening on port 3000')