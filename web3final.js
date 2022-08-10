/**
  * @notice This function is used to create an "Event".
  * @param name Event name
  * @param category Event category
  * @param description Event description
  * @param startTime Event startTime
  * @param endTime Event endTime
  * @param tokenCID Event tokenCID
  * @param venueTokenId venueTokenId
  * @param payNow pay venue fees now or later(true or false)
  * @param tokenAddress Fee token address
  * @param venueFeeAmount Venue fee amount
  * @param isEventPaid isEventPaid(true or false)
  * @param ticketPrice ticketPrice of event
  * @return Transaction Hash of the signed transaction
 */

const add = async (name, category, description, startTime, endTime, tokenCID, venueTokenId, payNow, tokenAddress, venueFeeAmount, isEventPaid, ticketPrice) => {
    let accounts = await getSelectedAccount().then((account) => {
        return account;
    });
    if (!accounts.length) {
        console.log("No account found");
    }
    try {
        const contractInstance = new window.web3.eth.Contract(
            eventAbi,
            eventAddress
        );
        // Get Gas Price
        let gasPrice = await window.web3.eth.getGasPrice();
        // Find gas limit
        let limit = await contractInstance.methods.add(name, category, description, startTime, endTime, tokenCID, venueTokenId, payNow, tokenAddress, venueFeeAmount, isEventPaid, ticketPrice).estimateGas({ from: account });
        // Call a function of the contract
        await contractInstance.methods.add(name, category, description, startTime, endTime, tokenCID, venueTokenId, payNow, tokenAddress, venueFeeAmount, isEventPaid, ticketPrice).send({
            from: account,
            value: 0,
            limit: limit + 5000,
            gasPrice: gasPrice
        }).on('transactionHash', function (hash) {
            console.log(hash);
            return hash
        })
    } catch (err) {
        console.log(err)
        throw err;
    }
}