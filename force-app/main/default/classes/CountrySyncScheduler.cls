global class CountrySyncScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        CountrySyncBatch batch = new CountrySyncBatch();
        Database.executeBatch(batch);
    }
}