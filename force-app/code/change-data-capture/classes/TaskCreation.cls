public class TaskCreation {
    
    private List<AccountChangeEvent> accountChanges;
    public TaskCreation(List<AccountChangeEvent> accountChanges) {
        this.accountChanges = accountChanges;
    }

    public void insertTask(){
        List<Task> tasks = new List<Task>();

        for(AccountChangeEvent accountChange : accountChanges){

            EventBus.ChangeEventHeader header = accountChange.ChangeEventHeader;

            System.debug('Header ' +  header);
            Task task = new Task();
            task.Subject = accountChange.Name;

            tasks.add(task);
        }

        if(!tasks.isEmpty()){
            insert tasks;
        }

        System.debug('Task Id ' +  tasks[0].Id);

    }
}
