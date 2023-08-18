import FungibleToken from 0x01
import UhanmiToken from 0x01

transaction (receiver: Address, amount: UFix64) {

    prepare (signer: AuthAccount) {
        // Borrow the UhanmiToken admin reference
        let minter = signer.borrow<&UhanmiToken.Admin>(from: UhanmiToken.AdminStorage)
        ?? panic("You are not the UhanmiToken admin")

        // Borrow the receiver's UhanmiToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&UhanmiToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
        ?? panic("Error: Check your UhanmiToken Vault status")
    }

    execute {
        // Mint UhanmiTokens using the admin minter reference
        let mintedTokens <- minter.mint(amount: amount)

        // Deposit minted tokens into the receiver's UhanmiToken Vault
        receiverVault.deposit(from: <-mintedTokens)

        log("Minted and deposited Uhanmi tokens successfully")
        log(amount.toString().concat(" Tokens minted and deposited"))
    }
}
