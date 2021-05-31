require('dotenv').config()

const Unichain = require('@uniworld/unichain-js')
const host = process.env[`${process.env.MODE}_HOST`]
const relayHost = process.env[`${process.env.MODE}_RELAY_HOST`]
const unichain = new Unichain({
    fullHost: host,
    solidityNode: relayHost,
    privateKey: process.env[`${process.env.MODE}_PRIVATE_KEY`]
})

module.exports = unichain

