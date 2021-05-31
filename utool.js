
require('dotenv').config()

const port = process.env.HOST_PORT || 6636

module.exports = {
  networks: {
    mainnet: {
      privateKey: process.env.PRODUCTION_PRIVATE_KEY,
      userFeePercentage: 100,
      feeLimit: 1e8,
      fullHost: 'https://node.unichain.world',
      network_id: '1'
    },
    testnet: {
      privateKey: process.env.DEVELOP_PRIVATE_KEY,
      userFeePercentage: 50,
      feeLimit: 1e8,
      fullHost: 'https://testnet-node.unichain.world',
      network_id: '2'
    },
    development: {
      privateKey: '',
      userFeePercentage: 0,
      feeLimit: 1e8,
      fullHost: 'http://127.0.0.1:' + port,
      network_id: '*'
    },
    compilers: {
      solc: {
        version: '0.4.25'
      }
    }
  }
}
