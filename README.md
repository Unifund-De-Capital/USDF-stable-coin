<p align="center"><b>USDF - The stable coin on UniChain network </b> </center>

USDF is the stable coin/token built on the UniChain network and backed by UniFund assets so that the value of each USDF is always equal to ~ $1. USDF is also the native token on UniFund platform, It can be used to investigate, transfer, exchange and many other operations. The USDF’s smart contract is public in this github link: https://github.com/Unifund-De-Capital/USDF-stable-coin

<b>How USDF works.</b> <br/>
Most of the stable coins like USDT, USDC … are backed by real assets such as the deposited money on the bank, the real estate … It guarantees the value and liquidity. Users that hold stable coins can redeem or exchange to real US dollars at any time.
USDF is not an exception. Its value is backed by another stable coin (USDT) and is transparent on the blockchain network. The following diagram describe how USDF works

<p align="center">
  <img src="https://i.ibb.co/mJT4N4z/Whats-App-Image-2021-05-31-at-16-39-54-1.jpg" alt="Picture 1. Deposit flow">
	<br/>
	Picture 1. Deposit flow
</p>


<p>
1.1. Users/Investor request to deposit on UniFund platform <br />
1.2. Users/investors will be redirected to a coin deposit gateway. Currently we support Binance Smart Chain and users can authen with Trust Wallet or Metamask/Binance extension <br />
1.3. After users/investors complete the deposit, UniFund will scan can confirm that amount, convert the coin/token to USDT value at current exchange rate <br />
2.1 USDF is minted on UniChain, the value is equal to the deposited value (at the deposited time) <br />
2.2. USDF is returned to UniFund and allocate to users/investors <br /> </p>


<p align="center">
  <img src="https://i.ibb.co/FW1HrYX/Whats-App-Image-2021-05-31-at-16-39-55.jpg" alt="Picture 2. Withdraw flow">
	<br/>
	Picture 2. Withdraw flow
</p>
<p>
1. Users/Investors request to withdraw from the UniFund platform. Currently, they can withdraw either USDT or USDF because of the same value <br />
2. USDT or USDF will be sent to users/investors wallet address<br />
3. If the request is USDT, the corresponding amount of USDF will be burnt on UniChain smart contract as the backed value has been withdrawn out of the system<br /><br/>

Unifund’s smart contract: https://github.com/Unifund-De-Capital/Unifund-Smartcontract

UniFund De Capital team
