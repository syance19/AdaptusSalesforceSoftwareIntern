public with sharing class AccountHandler extends TriggerHandler{

    @TestVisible
    protected override void beforeInsert() {
        for(Account acc: (List<Account>) Trigger.new) {
            if(acc.Name.length() > 70) {
                acc.addError(Constants.MAX_NAME_LENGTH_ERROR_MESSAGE);
            }else{
                acc.Name += Constants.CORPORATIVE_NAME_SUFFIX;
            }
        }
    }

    @TestVisible
    protected override void afterInsert() {
        createContactFromAccount((List<Account>) Trigger.new);
    }

    @TestVisible
    protected override void afterUpdate() {
        createContactFromAccount((List<Account>) Trigger.new);
    }

    private void createContactFromAccount(List<Account> accounts) {
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (Account acc : accounts) {
            Contact newContact = new Contact(
                FirstName = 'Candidate name',
                LastName = 'Candidate lastname',
                AccountId = acc.Id,
                Email = 'candidate_name@adaptus.com'
            );
            contactsToCreate.add(newContact);
        }

        if (!contactsToCreate.isEmpty()) {
            insert contactsToCreate;
        }
    }

    @TestVisible
    protected override void afterDelete() {
        List<Task> tasksToCreate = new List<Task>();
        
        for (Account acc : (List<Account>) Trigger.old) {
            Task newTask = new Task(
                Subject = 'Deleted account ' + acc.Name,
                ActivityDate = Date.today()   
            );
            tasksToCreate.add(newTask);
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}