public class AccountContactsController {
    private final Account account;
    public List<Contact> contacts { get; set; }
    public String selectedContactId { get; set; }
    private ApexPages.StandardController stdController;

    public AccountContactsController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.account = (Account)stdController.getRecord();
        loadContacts();
    }
    
    private void loadContacts() {
    contacts = [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c 
                FROM Contact 
                WHERE AccountId = :account.Id 
                LIMIT 1000];
}

    public PageReference setPrimaryContact() {
        // Logic to set selected contact as primary
        // Update all other contacts to not be primary
        List<Contact> updateContacts = new List<Contact>();
        for (Contact c : contacts) {
            if (c.Id == selectedContactId) {
                c.Is_Primary_Contact__c = true;
            } else {
                c.Is_Primary_Contact__c = false;
            }
            updateContacts.add(c);
        }
        update updateContacts;
        loadContacts(); // Reload the contacts list
        return null; // Stay on the same page
    }
}
