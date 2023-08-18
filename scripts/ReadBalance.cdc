import FungibleToken from 0x01
import UhanmiToken from 0x01

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, UhanmiToken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, UhanmiToken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- UhanmiToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, UhanmiToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &UhanmiToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&UhanmiToken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, UhanmiToken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&UhanmiToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, UhanmiToken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if UhanmiToken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a UhanmiToken vault")
        } else {
            log("This is not a UhanmiToken vault")
        }
    }
}
