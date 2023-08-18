import FungibleToken from 0x01
import UhanmiToken from 0x01

pub fun main(account: Address) {

    // Borrow the public vault capability and handle errors
    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&UhanmiToken.Vault{FungibleToken.Balance}>()
        ?? panic("Vault not found, setup might be incomplete")

    log("Vault setup verified successfully")
}
