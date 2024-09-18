trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete) {
    AccountHandler accHandler = new AccountHandler();
    accHandler.run();
}