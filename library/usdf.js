require('dotenv').config()
const unichain = require('./config')
const getContract = async (address) => {
    return await unichain.contract().at(address)
}

const getUsdfContract = async () => {
    return await getContract(process.env[`${process.env.MODE}_USDF_CONTRACT`])
}

const issue = async (to, value) => {
    try {
        const usdfContract = await getUsdfContract()
        let result = await usdfContract.issue(to, value).send({});
        return result
    } catch (error) {
        throw error
    }

}

const addWhileList = async (address) => {
    try {
        const usdfContract = await getUsdfContract()
        let result = await usdfContract.addWhileList(address).send();
        return result
    } catch (error) {
        throw error
    }

}

const burn = async (from, value) => {
    try {
        const usdfContract = await getUsdfContract()
        let result = await usdfContract.burn(from, value).send();
        return result
    } catch (error) {
        throw error
    }

}

const balanceOf = async (address) => {
    try {
        const usdfContract = await getUsdfContract()
        const balance = await usdfContract.balanceOf(address).call()
        return balance

    } catch (error) {
        throw error
    }
}
