import FungibleToken from 0x01
import UhanmiToken from 0x01

transaction() {

    // Define references
    let userVault: &UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, UhanmiToken.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow vault capability and set account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, UhanmiToken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- UhanmiToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, UhanmiToken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}
